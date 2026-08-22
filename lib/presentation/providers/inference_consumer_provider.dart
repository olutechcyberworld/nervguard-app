import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/ble_message.dart';
import 'ble_providers.dart';
import 'foreground_intervention_engine_provider.dart';
import 'inference_providers.dart';
import 'warmup_reset_providers.dart';

class InferenceConsumer extends Notifier<void> {
  StreamSubscription<BleMessage>? _subscription;
  bool _warmupDismissed = false;

  @override
  void build() {
    final bleService = ref.watch(bleServiceProvider);
    _subscription?.cancel();
    _subscription = bleService.events.listen(_onMessage);
    ref.onDispose(() => _subscription?.cancel());
    _warmupDismissed = false;
  }

  void _onMessage(BleMessage message) {
    switch (message) {
      case InferenceReceived(:final inference):
        ref.read(latestInferenceProvider.notifier).state = inference;
        if (!_warmupDismissed) {
          _warmupDismissed = true;
          ref.read(warmupActiveProvider.notifier).deactivate();
        }
      case FeatureVectorReceived(:final vector):
        ref.read(latestFeatureVectorProvider.notifier).state = vector;
      case InterventionTriggered triggered:
        ref
            .read(foregroundInterventionEngineProvider.notifier)
            .onIntervention(triggered);
      case BatteryLevelChanged(:final percent):
        ref.read(batteryLevelProvider.notifier).state = percent;
      case DeviceStateChanged():
      case BleConnectionStateChanged():
      case CalibrationStatsResult():
        // CalibrationStatsResult is consumed by CalibrationStatsNotifier
        // via readCalibrationStats() on the BleService stream; nothing
        // further needed here.
        break;
    }
  }
}

final inferenceConsumerProvider =
    NotifierProvider<InferenceConsumer, void>(InferenceConsumer.new);
