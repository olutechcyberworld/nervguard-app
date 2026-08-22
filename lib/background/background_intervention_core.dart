import 'dart:math' as math;

import 'package:uuid/uuid.dart';

import '../data/local/database/app_database.dart';
import '../domain/models/ble_message.dart';
import '../domain/services/notification_service.dart';

const _uuid = Uuid();

class BackgroundInterventionCore {
  BackgroundInterventionCore({
    required AppDatabase db,
    required NotificationService notificationService,
    required void Function(BleMessage message) onInterventionFired,
  })  : _db = db,
        _notifications = notificationService,
        _send = onInterventionFired;

  final AppDatabase _db;
  final NotificationService _notifications;
  final void Function(BleMessage) _send;

  int _consecutiveCount = 0;
  DateTime? _stressOnset;
  bool _escalated = false;
  DateTime? _cooldownExpiry;

  List<String> _mild = const [];
  List<String> _intensive = const [];

  void updatePool(
      {required List<String> mild, required List<String> intensive}) {
    _mild = List.unmodifiable(mild);
    _intensive = List.unmodifiable(intensive);
  }

  void resetState() {
    _consecutiveCount = 0;
    _stressOnset = null;
    _escalated = false;
    _cooldownExpiry = null;
  }

  Future<void> onInference(int inferenceClass, double probability) async {
    final now = DateTime.now();

    if (_cooldownExpiry != null && now.isBefore(_cooldownExpiry!)) return;

    if (inferenceClass >= 1) {
      _consecutiveCount++;
      _stressOnset ??= now;
    } else {
      _consecutiveCount = 0;
      _stressOnset = null;
      _escalated = false;
      return;
    }

    if (_consecutiveCount == 3 && _mild.isNotEmpty) {
      await _fire(tier: 'mild', pool: _mild);
      return;
    }

    if (_stressOnset != null &&
        now.difference(_stressOnset!).inMinutes >= 5 &&
        !_escalated &&
        _intensive.isNotEmpty) {
      _escalated = true;
      await _fire(tier: 'intensive', pool: _intensive);
    }
  }

  Future<void> _fire({required String tier, required List<String> pool}) async {
    final intervention = _drawRandom(pool);
    final logId = _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;

    await _db.interventionLogDao.insertLog(InterventionLogsCompanion.insert(
      id: logId,
      intervention: intervention,
      tier: tier,
      triggeredAt: now,
    ));

    await _notifications.showIntervention(
      title: tier == 'intensive' ? 'Stress Intervention' : 'Stress Relief',
      body: intervention,
      tier: tier,
    );

    _cooldownExpiry = DateTime.now().add(const Duration(minutes: 5));

    _send(InterventionTriggered(
      logId: logId,
      intervention: intervention,
      tier: tier,
    ));
  }

  String _drawRandom(List<String> pool) =>
      pool[math.Random().nextInt(pool.length)];
}
