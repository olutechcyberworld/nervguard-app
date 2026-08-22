import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/domain/services/fake_ble_service.dart';
import 'package:nervguard/presentation/providers/ble_providers.dart';
import 'package:nervguard/presentation/providers/device_state_provider.dart';
import 'package:nervguard/presentation/providers/warmup_reset_providers.dart';

void main() {
  late FakeBleService fakeBleService;
  late ProviderContainer container;

  setUp(() {
    fakeBleService = FakeBleService();
    container = ProviderContainer(
      overrides: [bleServiceProvider.overrideWithValue(fakeBleService)],
    );
    addTearDown(container.dispose);
  });

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  group('WarmupActiveNotifier', () {
    test('defaults to false before MONITORING entry', () async {
      await container.read(deviceStateNotifierProvider.future);
      expect(container.read(warmupActiveProvider), isFalse);
    });

    test('activates automatically on MONITORING entry', () async {
      await container.read(deviceStateNotifierProvider.future);
      container.read(warmupActiveProvider); // force build(), attach ref.listen
      fakeBleService.simulateMonitoring(stressed: false);
      await pump();
      expect(container.read(warmupActiveProvider), isTrue);
    });

    test('deactivate() turns it off directly, simulating InferenceConsumer',
        () async {
      await container.read(deviceStateNotifierProvider.future);
      container.read(warmupActiveProvider);
      fakeBleService.simulateMonitoring(stressed: false);
      await pump();
      expect(container.read(warmupActiveProvider), isTrue);

      container.read(warmupActiveProvider.notifier).deactivate();
      expect(container.read(warmupActiveProvider), isFalse);
    });

    test('the 65-second timer deactivates it if nothing else does', () {
      fakeAsync((async) {
        container.read(deviceStateNotifierProvider.future);
        async.flushMicrotasks();
        container.read(warmupActiveProvider);

        fakeBleService.simulateMonitoring(stressed: false);
        async.flushMicrotasks();
        expect(container.read(warmupActiveProvider), isTrue);

        async.elapse(const Duration(seconds: 65));
        expect(container.read(warmupActiveProvider), isFalse);
      });
    });
  });

  group('ResetCountdownNotifier', () {
    test('defaults to 15 before PENDING_RESET entry', () async {
      await container.read(deviceStateNotifierProvider.future);
      expect(container.read(resetCountdownProvider), 15);
    });

    test('counts down by 1 each second while PENDING_RESET is active', () {
      fakeAsync((async) {
        container.read(deviceStateNotifierProvider.future);
        async.flushMicrotasks();
        container.read(resetCountdownProvider);

        final deviceNotifier =
            container.read(deviceStateNotifierProvider.notifier);
        fakeBleService.simulateConnect();
        async.flushMicrotasks();
        deviceNotifier.requestReset();
        async.flushMicrotasks();

        expect(container.read(resetCountdownProvider), 15);
        async.elapse(const Duration(seconds: 3));
        expect(container.read(resetCountdownProvider), 12);
      });
    });

    test('resets to 15 when the device state leaves PENDING_RESET', () {
      fakeAsync((async) {
        container.read(deviceStateNotifierProvider.future);
        async.flushMicrotasks();
        container.read(resetCountdownProvider);

        final deviceNotifier =
            container.read(deviceStateNotifierProvider.notifier);
        fakeBleService.simulateConnect();
        async.flushMicrotasks();
        deviceNotifier.requestReset();
        async.flushMicrotasks();

        async.elapse(const Duration(seconds: 5));
        expect(container.read(resetCountdownProvider), 10);

        fakeBleService.sendCommand(0x05); // confirmReset → UNCALIBRATED
        async.flushMicrotasks();

        expect(container.read(resetCountdownProvider), 15);
      });
    });
  });
}
