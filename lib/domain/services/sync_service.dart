import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/local/database/app_database.dart';
import '../../data/remote/supabase_sync_client.dart';

const _defaultBatchLimit = 50;

/// Pushes unsynced local rows to Supabase in the dependency order locked
/// in Phase 3.6: monitoring_sessions, intervention_logs,
/// preference_weights, and calibration_stats in Tier 1 (parallel),
/// followed by stress_events in Tier 2 (sequential, after Tier 1
/// completes), since stress_events declares a foreign key on
/// monitoring_sessions(id) both locally (Sprint 1 schema) and remotely
/// (Sprint 1 DDL).
class SyncService {
  SyncService({
    required AppDatabase database,
    required SupabaseSyncClient syncClient,
    required String? Function() currentUserId,
    Connectivity? connectivity,
    Duration periodicInterval = const Duration(minutes: 15),
  })  : _db = database,
        _syncClient = syncClient,
        _currentUserId = currentUserId,
        _connectivity = connectivity ?? Connectivity(),
        _periodicInterval = periodicInterval;

  final AppDatabase _db;
  final SupabaseSyncClient _syncClient;
  final String? Function() _currentUserId;
  final Connectivity _connectivity;
  final Duration _periodicInterval;

  bool _syncing = false;
  Timer? _periodicTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _wasOffline = false;

  /// Wires up the two trigger sources locked in Phase 3.6: a
  /// connectivity transition from offline to online, and a 15-minute
  /// periodic timer while the app is foregrounded. Background sync is
  /// explicitly out of v1 scope; this must only be started from
  /// main-isolate composition.
  void start() {
    _periodicTimer?.cancel();
    _periodicTimer = Timer.periodic(_periodicInterval, (_) => sync());

    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline && _wasOffline) {
        sync();
      }
      _wasOffline = !isOnline;
    });
  }

  void dispose() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
    _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }

  /// Runs one full sync pass. A guard ensures only one pass runs at a
  /// time; an overlapping trigger simply no-ops rather than queues,
  /// since the next periodic or connectivity trigger will pick up
  /// whatever remains unsynced. synced_at staying NULL on any row that
  /// failed to push IS the retry queue; no separate retry mechanism
  /// is needed.
  Future<void> sync() async {
    if (_syncing) return;

    final userId = _currentUserId();
    if (userId == null || userId.isEmpty) {
      return;
    }

    _syncing = true;
    try {
      await Future.wait([
        _syncMonitoringSessions(userId),
        _syncInterventionLogs(userId),
        _syncPreferenceWeights(userId),
        _syncCalibrationStats(userId),
      ]);
      await _syncStressEvents(userId);
    } finally {
      _syncing = false;
    }
  }

  Future<void> _syncMonitoringSessions(String userId) async {
    final dao = _db.monitoringSessionDao;
    final batch = await dao.getUnsyncedBatch(_defaultBatchLimit);
    if (batch.isEmpty) return;

    final rows = batch
        .map((row) => {
              'id': row.id,
              'user_id': userId,
              'started_at': DateTime.fromMillisecondsSinceEpoch(row.startedAt)
                  .toUtc()
                  .toIso8601String(),
              'ended_at': row.endedAt == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row.endedAt!)
                      .toUtc()
                      .toIso8601String(),
              'avg_stress_prob': row.avgStressProb,
              'stress_event_count': row.stressEventCount,
              'intervention_count': row.interventionCount,
            })
        .toList();

    try {
      await _syncClient.upsertMonitoringSessions(rows);
      await dao.markSynced(batch.map((r) => r.id).toList());
    } catch (_) {
      // Any failure (network, timeout, Postgrest, or otherwise) leaves
      // this batch unsynced; the next sync() pass retries it. A failure
      // in one table's push must not prevent the other tables in this
      // pass from being attempted or prevent Tier 2 from running once
      // Tier 1's Future.wait completes.
    }
  }

  Future<void> _syncInterventionLogs(String userId) async {
    final dao = _db.interventionLogDao;
    final batch = await dao.getUnsyncedBatch(_defaultBatchLimit);
    if (batch.isEmpty) return;

    final rows = batch
        .map((row) => {
              'id': row.id,
              'user_id': userId,
              'intervention': row.intervention,
              'tier': row.tier,
              'triggered_at':
                  DateTime.fromMillisecondsSinceEpoch(row.triggeredAt)
                      .toUtc()
                      .toIso8601String(),
              'status': row.status,
              'acknowledged_at': row.acknowledgedAt == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(row.acknowledgedAt!)
                      .toUtc()
                      .toIso8601String(),
            })
        .toList();

    try {
      await _syncClient.upsertInterventionLogs(rows);
      await dao.markSynced(batch.map((r) => r.id).toList());
    } catch (_) {
      // retried next pass
    }
  }

  Future<void> _syncPreferenceWeights(String userId) async {
    final dao = _db.preferenceWeightsDao;
    final batch = await dao.getUnsyncedBatch(_defaultBatchLimit);
    if (batch.isEmpty) return;

    final rows = batch
        .map((row) => {
              'user_id': userId,
              'intervention': row.intervention,
              'weight': row.weight,
              'updated_at': DateTime.fromMillisecondsSinceEpoch(row.updatedAt)
                  .toUtc()
                  .toIso8601String(),
            })
        .toList();

    try {
      await _syncClient.upsertPreferenceWeights(rows);
      await dao.markSynced(batch.map((r) => r.intervention).toList());
    } catch (_) {
      // retried next pass
    }
  }

  Future<void> _syncCalibrationStats(String userId) async {
    final dao = _db.calibrationStatsDao;
    final batch = await dao.getUnsyncedBatch(_defaultBatchLimit);
    if (batch.isEmpty) return;

    final row = batch.first;
    final payload = {
      'user_id': userId,
      'calibrated_at': DateTime.fromMillisecondsSinceEpoch(row.calibratedAt)
          .toUtc()
          .toIso8601String(),
      'means': row.means,
      'stds': row.stds,
    };

    try {
      await _syncClient.upsertCalibrationStats(payload);
      await dao.markSynced(const []);
    } catch (_) {
      // retried next pass
    }
  }

  Future<void> _syncStressEvents(String userId) async {
    final dao = _db.stressEventDao;
    final batch = await dao.getUnsyncedBatch(_defaultBatchLimit);
    if (batch.isEmpty) return;

    final rows = batch
        .map((row) => {
              'id': row.id,
              'user_id': userId,
              'session_id': row.sessionId,
              'event_type': row.eventType,
              'occurred_at': DateTime.fromMillisecondsSinceEpoch(row.occurredAt)
                  .toUtc()
                  .toIso8601String(),
              'stress_class': row.stressClass,
              'probability': row.probability,
            })
        .toList();

    try {
      await _syncClient.upsertStressEvents(rows);
      await dao.markSynced(batch.map((r) => r.id).toList());
    } catch (_) {
      // An FK violation here means a parent monitoring_sessions row
      // hasn't synced yet (or failed within this same pass). Left
      // unsynced; the next pass retries, by which point Tier 1 should
      // have succeeded.
    }
  }
}
