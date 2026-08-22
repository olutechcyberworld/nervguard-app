import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/core/constants/ble_constants.dart';
import 'package:nervguard/domain/models/device_state.dart';
import 'package:nervguard/domain/services/fake_ble_service.dart';
import 'package:nervguard/presentation/providers/ble_providers.dart';
import 'package:nervguard/presentation/providers/device_state_provider.dart';
import 'package:drift/native.dart';
import 'package:nervguard/data/local/database/app_database.dart';
import 'package:nervguard/presentation/providers/infrastructure_providers.dart';
import 'package:nervguard/presentation/providers/calibration_stats_provider.dart';

void main() {
  late FakeBleService fakeBleService;
  late ProviderContainer container;

  late AppDatabase db;

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

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  test('initial state is Uncalibrated before any DeviceStateChanged event',
      () async {
    final state = await container.read(deviceStateNotifierProvider.future);
    expect(state, isA<Uncalibrated>());
  });

  test('transition guards reflect Uncalibrated state', () async {
    await container.read(deviceStateNotifierProvider.future);
    final notifier = container.read(deviceStateNotifierProvider.notifier);
    expect(notifier.canStartCalibration, isTrue);
    expect(notifier.canStartMonitoring, isFalse);
    expect(notifier.canStopMonitoring, isFalse);
    expect(notifier.canRequestReset, isTrue);
    expect(notifier.canConfirmReset, isFalse);
  });

  test('simulateConnect resolves to Idle', () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateConnect();
    await pump();
    expect(container.read(deviceStateNotifierProvider).value, isA<Idle>());
  });

  test('CALIBRATING progress settles to Idle after the sequence completes',
      () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateCalibrationSequence();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    expect(
        container.read(deviceStateNotifierProvider).value, isA<Calibrating>());

    await Future<void>.delayed(const Duration(milliseconds: 700));
    expect(container.read(deviceStateNotifierProvider).value, isA<Idle>());
  });

  test('ERROR maps a known error byte to the corresponding DeviceError',
      () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateError(BleConstants.errTfliteAllocFailure);
    await pump();
    final state = container.read(deviceStateNotifierProvider).value;
    expect(state, isA<DeviceErrorState>());
    expect((state as DeviceErrorState).error, DeviceError.tfliteAllocFailure);
  });

  test('ERROR maps an unrecognised byte to DeviceError.unknown', () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateError(0xFF);
    await pump();
    final state = container.read(deviceStateNotifierProvider).value;
    expect((state as DeviceErrorState).error, DeviceError.unknown);
  });

  test('PendingReset captures the state that preceded requestReset', () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateConnect();
    await pump();

    final notifier = container.read(deviceStateNotifierProvider.notifier);
    await notifier.requestReset();
    await pump();

    final state = container.read(deviceStateNotifierProvider).value;
    expect(state, isA<PendingReset>());
    expect((state as PendingReset).previousState, isA<Idle>());
  });

  test('confirmReset transitions to Uncalibrated', () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateConnect();
    await pump();

    final notifier = container.read(deviceStateNotifierProvider.notifier);
    await notifier.requestReset();
    await pump();
    await notifier.confirmReset();
    await pump();

    expect(
        container.read(deviceStateNotifierProvider).value, isA<Uncalibrated>());
  });

  test('requestReset throws when called from an invalid state', () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateConnect();
    await pump();

    final notifier = container.read(deviceStateNotifierProvider.notifier);
    await notifier.requestReset();
    await pump();

    expect(() => notifier.requestReset(), throwsStateError);
  });

  test('CALIBRATING -> IDLE triggers a calibration stats refresh', () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateCalibrationSequence();
    await Future<void>.delayed(const Duration(milliseconds: 700));
    await Future<void>.delayed(
        Duration.zero); // let refresh()'s microtasks settle

    final stats = container.read(calibrationStatsNotifierProvider).value;
    expect(stats, isNotNull);
  });

  test('MONITORING -> IDLE (stopMonitoring) does not trigger a refresh',
      () async {
    await container.read(deviceStateNotifierProvider.future);
    fakeBleService.simulateConnect();
    await Future<void>.delayed(Duration.zero);

    final notifier = container.read(deviceStateNotifierProvider.notifier);
    fakeBleService.simulateMonitoring(stressed: false);
    await Future<void>.delayed(Duration.zero);
    await notifier.stopMonitoring();
    await Future<void>.delayed(Duration.zero);

    final stats = container.read(calibrationStatsNotifierProvider).value;
    expect(stats, isNull);
  });
}
