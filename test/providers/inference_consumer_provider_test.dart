import 'package:drift/native.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/data/local/database/app_database.dart';
import 'package:nervguard/domain/models/intervention_overlay_state.dart';
import 'package:nervguard/domain/services/fake_ble_service.dart';
import 'package:nervguard/presentation/providers/ble_providers.dart';
import 'package:nervguard/presentation/providers/foreground_intervention_engine_provider.dart';
import 'package:nervguard/presentation/providers/inference_consumer_provider.dart';
import 'package:nervguard/presentation/providers/inference_providers.dart';
import 'package:nervguard/presentation/providers/infrastructure_providers.dart';
import 'package:nervguard/presentation/providers/warmup_reset_providers.dart';

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

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  test('updates latestInferenceProvider and latestFeatureVectorProvider', () {
    fakeAsync((async) {
      container.read(inferenceConsumerProvider); // attach listener first
      fakeBleService.simulateMonitoring(stressed: true);
      async.elapse(const Duration(seconds: 5)); // first periodic tick

      final inference = container.read(latestInferenceProvider);
      final featureVector = container.read(latestFeatureVectorProvider);
      expect(inference, isNotNull);
      expect(inference!.inferenceClass, 1);
      expect(featureVector, isNotNull);
    });
  });

  test('deactivates warmupActiveProvider on the first inference', () {
    fakeAsync((async) {
      container.read(warmupActiveProvider); // attach its listener
      container.read(inferenceConsumerProvider);

      fakeBleService.simulateMonitoring(stressed: false);
      async.elapse(const Duration(seconds: 5));
      expect(container.read(warmupActiveProvider), isFalse);
    });
  });

  test('routes InterventionTriggered to ForegroundInterventionEngine',
      () async {
    container.read(inferenceConsumerProvider);
    await container.read(
        foregroundInterventionEngineProvider.future); // resolves NoOverlay

    fakeBleService.simulateInterventionTriggered(
      logId: 'log-1',
      intervention: 'Lo-fi music',
      tier: 'mild',
    );
    await pump();

    final overlay = container.read(foregroundInterventionEngineProvider).value;
    expect(overlay, isA<OverlayActive>());
    expect((overlay as OverlayActive).logId, 'log-1');
  });
}
