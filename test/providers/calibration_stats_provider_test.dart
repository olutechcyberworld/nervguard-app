import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/data/local/database/app_database.dart';
import 'package:nervguard/domain/services/fake_ble_service.dart';
import 'package:nervguard/presentation/providers/ble_providers.dart';
import 'package:nervguard/presentation/providers/calibration_stats_provider.dart';
import 'package:nervguard/presentation/providers/infrastructure_providers.dart';

void main() {
  late FakeBleService fakeBleService;
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    fakeBleService = FakeBleService();
    db = AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        bleServiceProvider.overrideWithValue(fakeBleService),
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);
  });

  test('starts with no calibration data', () async {
    final stats = await container.read(calibrationStatsNotifierProvider.future);
    expect(stats, isNull);
  });

  test('refresh() reads from BleService and exposes the result', () async {
    await container.read(calibrationStatsNotifierProvider.future);
    final notifier = container.read(calibrationStatsNotifierProvider.notifier);

    await notifier.refresh();

    final stats = container.read(calibrationStatsNotifierProvider).value;
    expect(stats, isNotNull);
    expect(stats!.means, hasLength(13));
    expect(stats.stds, hasLength(13));
  });

  test('refresh() persists the result to Drift', () async {
    await container.read(calibrationStatsNotifierProvider.future);
    final notifier = container.read(calibrationStatsNotifierProvider.notifier);

    await notifier.refresh();

    final stored = await db.calibrationStatsDao.getStats();
    expect(stored, isNotNull);
    expect(stored!.means, hasLength(13));
  });
}
