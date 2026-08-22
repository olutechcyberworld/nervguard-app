import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/data/local/database/app_database.dart';
import 'package:nervguard/data/preferences/app_preferences.dart';
import 'package:nervguard/domain/services/fake_ble_service.dart';
import 'package:nervguard/presentation/providers/ble_providers.dart';
import 'package:nervguard/presentation/providers/infrastructure_providers.dart';
import 'package:nervguard/presentation/providers/intervention_pool_provider.dart';
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

  test('starts empty when no pool has been configured', () async {
    final pool = await container.read(interventionPoolProvider.future);
    expect(pool.mild, isEmpty);
    expect(pool.intensive, isEmpty);
  });

  test('setPools persists to SharedPreferences and updates state', () async {
    await container.read(interventionPoolProvider.future);
    final notifier = container.read(interventionPoolProvider.notifier);

    await notifier.setPools(
      mild: ['Lo-fi music', 'Box breathing'],
      intensive: ['4-7-8 Breathing'],
    );

    final pool = container.read(interventionPoolProvider).value;
    expect(pool!.mild.map((i) => i.name), ['Lo-fi music', 'Box breathing']);
    expect(pool.intensive.map((i) => i.name), ['4-7-8 Breathing']);
    expect(pool.mild.every((i) => i.weight == 1.0), isTrue);
  });

  test('build() reflects an existing preference_weights weight', () async {
    await db.preferenceWeightsDao.upsertWeight(
      'Lo-fi music',
      1.3,
      DateTime.now().millisecondsSinceEpoch,
    );
    final prefsForTest = await container.read(appPreferencesProvider.future);
    await prefsForTest.setMildPool(['Lo-fi music']);

    final pool = await container.read(interventionPoolProvider.future);
    expect(pool.mild.single.weight, closeTo(1.3, 1e-9));
  });

  test('refreshWeight updates the in-memory weight for a matching item',
      () async {
    final notifier = container.read(interventionPoolProvider.notifier);
    await notifier.setPools(mild: ['Lo-fi music'], intensive: const []);

    await notifier.refreshWeight('Lo-fi music', 1.1);

    final pool = container.read(interventionPoolProvider).value;
    expect(pool!.mild.single.weight, closeTo(1.1, 1e-9));
  });

  test('refreshWeight leaves non-matching items unchanged', () async {
    final notifier = container.read(interventionPoolProvider.notifier);
    await notifier
        .setPools(mild: ['Lo-fi music', 'Box breathing'], intensive: const []);

    await notifier.refreshWeight('Lo-fi music', 1.1);

    final pool = container.read(interventionPoolProvider).value;
    final boxBreathing =
        pool!.mild.firstWhere((i) => i.name == 'Box breathing');
    expect(boxBreathing.weight, 1.0);
  });
}
