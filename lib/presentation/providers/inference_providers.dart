import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/correlated_window.dart';
import '../../domain/models/feature_vector.dart';
import '../../domain/models/inference_output.dart';

class LatestInferenceNotifier extends Notifier<InferenceOutput?> {
  @override
  InferenceOutput? build() => null;
}

final latestInferenceProvider =
    NotifierProvider<LatestInferenceNotifier, InferenceOutput?>(
        LatestInferenceNotifier.new);

class LatestFeatureVectorNotifier extends Notifier<FeatureVector?> {
  @override
  FeatureVector? build() => null;
}

final latestFeatureVectorProvider =
    NotifierProvider<LatestFeatureVectorNotifier, FeatureVector?>(
        LatestFeatureVectorNotifier.new);

class BatteryLevelNotifier extends Notifier<int> {
  @override
  int build() => 100; // optimistic default until first BLE notification
}

final batteryLevelProvider =
    NotifierProvider<BatteryLevelNotifier, int>(BatteryLevelNotifier.new);

final correlatedWindowProvider = Provider<CorrelatedWindow?>((ref) {
  final inference = ref.watch(latestInferenceProvider);
  final featureVector = ref.watch(latestFeatureVectorProvider);
  if (inference == null || featureVector == null) return null;
  final diff = (inference.windowSequence - featureVector.windowSequence) % 256;
  final wrapped = diff > 128 ? 256 - diff : diff;
  if (wrapped > 5) return null;
  return CorrelatedWindow(inference: inference, featureVector: featureVector);
});
