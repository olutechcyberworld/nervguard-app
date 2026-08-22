import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/data/local/database/app_database.dart';
import 'package:nervguard/data/preferences/app_preferences.dart';
import 'package:nervguard/domain/models/ble_message.dart';
import 'package:nervguard/domain/models/intervention_overlay_state.dart';
import 'package:nervguard/domain/services/fake_ble_service.dart';
import 'package:nervguard/presentation/providers/ble_providers.dart';
import 'package:nervguard/presentation/providers/foreground_intervention_engine_provider.dart';
import 'package:nervguard/presentation/providers/infrastructure_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late FakeBleService fakeBleService;
  late ProviderContainer container;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    fakeBleService = FakeBleService();
    SharedPreferences.setMockInitialValues({});
    final prefs = await AppPreferences.create();

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        bleServiceProvider.overrideWithValue(fakeBleService),
        appPreferencesProvider.overrideWith((ref) async => prefs),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
  });

  test('build() resolves to NoOverlay when nothing unacknowledged exists',
      () async {
    final state =
        await container.read(foregroundInterventionEngineProvider.future);
    expect(state, isA<NoOverlay>());
  });

  test('build() recovers a triggered, unacknowledged log within the window',
      () async {
    await db.interventionLogDao.insertLog(InterventionLogsCompanion.insert(
      id: 'log-recover',
      intervention: 'Box breathing',
      tier: 'mild',
      triggeredAt: DateTime.now().millisecondsSinceEpoch,
    ));

    final state =
        await container.read(foregroundInterventionEngineProvider.future);
    expect(state, isA<OverlayActive>());
    expect((state as OverlayActive).logId, 'log-recover');
  });

  test('build() ignores a log outside the 5-minute recovery window', () async {
    final old = DateTime.now()
        .subtract(const Duration(minutes: 10))
        .millisecondsSinceEpoch;
    await db.interventionLogDao.insertLog(InterventionLogsCompanion.insert(
      id: 'log-old',
      intervention: 'Box breathing',
      tier: 'mild',
      triggeredAt: old,
    ));

    final state =
        await container.read(foregroundInterventionEngineProvider.future);
    expect(state, isA<NoOverlay>());
  });

  test('onIntervention activates the overlay', () async {
    await container.read(foregroundInterventionEngineProvider.future);
    final notifier =
        container.read(foregroundInterventionEngineProvider.notifier);

    notifier.onIntervention(const InterventionTriggered(
      logId: 'log-new',
      intervention: 'Nature sounds',
      tier: 'mild',
    ));

    final state = container.read(foregroundInterventionEngineProvider).value;
    expect(state, isA<OverlayActive>());
    expect((state as OverlayActive).logId, 'log-new');
  });

  test(
      'onIntervention dedups against an already-active overlay with the same logId',
      () async {
    await container.read(foregroundInterventionEngineProvider.future);
    final notifier =
        container.read(foregroundInterventionEngineProvider.notifier);

    notifier.onIntervention(const InterventionTriggered(
      logId: 'log-dup',
      intervention: 'Nature sounds',
      tier: 'mild',
    ));
    final first = container.read(foregroundInterventionEngineProvider).value
        as OverlayActive;

    notifier.onIntervention(const InterventionTriggered(
      logId: 'log-dup',
      intervention: 'Different item entirely',
      tier: 'intensive',
    ));
    final second = container.read(foregroundInterventionEngineProvider).value
        as OverlayActive;

    expect(second.intervention, first.intervention);
    expect(second.tier, first.tier);
  });

  test(
      'respond(helped: true) updates status, computes EMA weight, clears overlay',
      () async {
    await db.interventionLogDao.insertLog(InterventionLogsCompanion.insert(
      id: 'log-respond',
      intervention: 'Lo-fi music',
      tier: 'mild',
      triggeredAt: DateTime.now().millisecondsSinceEpoch,
    ));
    await container.read(foregroundInterventionEngineProvider.future);
    final notifier =
        container.read(foregroundInterventionEngineProvider.notifier);

    await notifier.respond(helped: true);

    final state = container.read(foregroundInterventionEngineProvider).value;
    expect(state, isA<NoOverlay>());

    final weight = await db.preferenceWeightsDao.getWeight('Lo-fi music');
    expect(weight, isNotNull);
    expect(weight!.weight, closeTo(1.1, 1e-9));
  });

  test('respond(helped: false) computes the skip-side EMA weight', () async {
    await db.interventionLogDao.insertLog(InterventionLogsCompanion.insert(
      id: 'log-skip',
      intervention: 'Box breathing',
      tier: 'mild',
      triggeredAt: DateTime.now().millisecondsSinceEpoch,
    ));
    await container.read(foregroundInterventionEngineProvider.future);
    final notifier =
        container.read(foregroundInterventionEngineProvider.notifier);

    await notifier.respond(helped: false);

    final weight = await db.preferenceWeightsDao.getWeight('Box breathing');
    expect(weight!.weight, closeTo(0.9, 1e-9));
  });

  test('respond() is a no-op when there is no active overlay', () async {
    await container.read(foregroundInterventionEngineProvider.future);
    final notifier =
        container.read(foregroundInterventionEngineProvider.notifier);

    await notifier.respond(helped: true);

    final state = container.read(foregroundInterventionEngineProvider).value;
    expect(state, isA<NoOverlay>());
  });
}
