import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nervguard/data/local/database/app_database.dart';
import 'package:nervguard/data/remote/supabase_sync_client.dart';
import 'package:nervguard/domain/services/sync_service.dart';
import 'package:uuid/uuid.dart';

class MockSupabaseSyncClient extends Mock implements SupabaseSyncClient {}

void main() {
  late AppDatabase db;
  late MockSupabaseSyncClient syncClient;
  late SyncService syncService;
  const userId = 'test-user-id';

  setUpAll(() {
    registerFallbackValue(<Map<String, dynamic>>[]);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    syncClient = MockSupabaseSyncClient();
    syncService = SyncService(
      database: db,
      syncClient: syncClient,
      currentUserId: () => userId,
    );

    when(() => syncClient.upsertMonitoringSessions(any()))
        .thenAnswer((_) async {});
    when(() => syncClient.upsertInterventionLogs(any()))
        .thenAnswer((_) async {});
    when(() => syncClient.upsertPreferenceWeights(any()))
        .thenAnswer((_) async {});
    when(() => syncClient.upsertCalibrationStats(any()))
        .thenAnswer((_) async {});
    when(() => syncClient.upsertStressEvents(any())).thenAnswer((_) async {});
  });

  tearDown(() => db.close());

  test('sync() makes no Supabase calls in local-only mode', () async {
    final localOnlySync = SyncService(
      database: db,
      syncClient: syncClient,
      currentUserId: () => null,
    );

    await localOnlySync.sync();

    verifyNever(() => syncClient.upsertMonitoringSessions(any()));
    verifyNever(() => syncClient.upsertInterventionLogs(any()));
  });

  test('sync() makes no Supabase calls when there is nothing unsynced',
      () async {
    await syncService.sync();

    verifyNever(() => syncClient.upsertMonitoringSessions(any()));
    verifyNever(() => syncClient.upsertInterventionLogs(any()));
    verifyNever(() => syncClient.upsertPreferenceWeights(any()));
    verifyNever(() => syncClient.upsertCalibrationStats(any()));
    verifyNever(() => syncClient.upsertStressEvents(any()));
  });

  test('pushes an unsynced monitoring session and marks it synced on success',
      () async {
    const sessionId = '11111111-1111-1111-1111-111111111111';
    await db.monitoringSessionDao.startSession(sessionId, 1000);

    await syncService.sync();

    final captured =
        verify(() => syncClient.upsertMonitoringSessions(captureAny()))
            .captured
            .single as List<Map<String, dynamic>>;
    expect(captured, hasLength(1));
    expect(captured.first['id'], sessionId);
    expect(captured.first['user_id'], userId);

    final stillUnsynced = await db.monitoringSessionDao.getUnsyncedBatch(50);
    expect(stillUnsynced, isEmpty);
  });

  test('leaves a row unsynced when the push fails', () async {
    const sessionId = '22222222-2222-2222-2222-222222222222';
    await db.monitoringSessionDao.startSession(sessionId, 2000);

    when(() => syncClient.upsertMonitoringSessions(any()))
        .thenThrow(Exception('network error'));

    await syncService.sync();

    final stillUnsynced = await db.monitoringSessionDao.getUnsyncedBatch(50);
    expect(stillUnsynced, hasLength(1));
    expect(stillUnsynced.first.id, sessionId);
  });

  test('stress_events sync is attempted only after Tier 1 completes', () async {
    const sessionId = '33333333-3333-3333-3333-333333333333';
    await db.monitoringSessionDao.startSession(sessionId, 3000);
    await db.stressEventDao.insertEvent(StressEventsCompanion.insert(
      id: const Uuid().v4(),
      sessionId: sessionId,
      eventType: 'onset',
      occurredAt: 3500,
    ));

    final callOrder = <String>[];
    when(() => syncClient.upsertMonitoringSessions(any()))
        .thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      callOrder.add('monitoring_sessions');
    });
    when(() => syncClient.upsertStressEvents(any())).thenAnswer((_) async {
      callOrder.add('stress_events');
    });

    await syncService.sync();

    expect(callOrder, ['monitoring_sessions', 'stress_events']);
  });

  test('a concurrent sync() call while one is in flight is a no-op', () async {
    const sessionId = '44444444-4444-4444-4444-444444444444';
    await db.monitoringSessionDao.startSession(sessionId, 4000);

    var callCount = 0;
    when(() => syncClient.upsertMonitoringSessions(any()))
        .thenAnswer((_) async {
      callCount++;
      await Future<void>.delayed(const Duration(milliseconds: 30));
    });

    final first = syncService.sync();
    final second = syncService.sync();

    await Future.wait([first, second]);

    expect(callCount, 1);
  });
}
