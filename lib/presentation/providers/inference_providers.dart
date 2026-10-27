import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/correlated_window.dart';
import '../../domain/models/feature_vector.dart';
import '../../domain/models/inference_output.dart';
import 'ble_providers.dart';

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

/// Short history of recent feature vectors, newest last.
///
/// The firmware sends the feature vector of window N first and the stress
/// result for window N a few seconds later (the on-device model takes about
/// 3.6 s per window). Showing "latest features" beside "latest result" therefore
/// pairs window N+1 with window N for most of every cycle. Keeping a few recent
/// vectors lets the dashboard show the features of the window the result is for.
class RecentFeatureVectorsNotifier extends Notifier<List<FeatureVector>> {
  static const int _keep = 8;

  @override
  List<FeatureVector> build() => const [];

  void add(FeatureVector vector) {
    final next = [...state, vector];
    state = next.length > _keep ? next.sublist(next.length - _keep) : next;
  }
}

final recentFeatureVectorsProvider =
    NotifierProvider<RecentFeatureVectorsNotifier, List<FeatureVector>>(
        RecentFeatureVectorsNotifier.new);

/// The feature vector of the same window the latest stress result refers to
/// (matched by the window sequence number both packets carry). Before the first
/// result, or if no recent vector matches, it falls back to the newest vector.
final windowFeatureVectorProvider = Provider<FeatureVector?>((ref) {
  final inference = ref.watch(latestInferenceProvider);
  final recent = ref.watch(recentFeatureVectorsProvider);
  if (recent.isEmpty) return null;
  if (inference == null) return recent.last;
  for (final vector in recent.reversed) {
    if (vector.windowSequence == inference.windowSequence) return vector;
  }
  return recent.last;
});

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

/// FIX: Feature Vector (A5B30004) is deliberately excluded from the
/// connection-time CCCD subscriptions in the nine-phase BLE connection
/// sequence (see app_architecture_handoff.md, Phase 7 — "not A5B30004").
/// The design intent was for the dashboard screen to subscribe only
/// while it is actually visible, for bandwidth/battery reasons, and
/// unsubscribe when navigated away. That trigger was missing from the
/// current implementation: RealBleService.subscribeFeatureVector() and
/// unsubscribeFeatureVector() both existed and were correctly wired to
/// the background isolate, but nothing in the widget tree ever called
/// either one, so the firmware was never asked to notify on that
/// characteristic and EDA/Temp/HRV/Acc — everything sourced from
/// FeatureVector — stayed frozen at their initial null state
/// indefinitely, while Inference-sourced fields (Stress, Window)
/// continued working normally since A5B30003 IS subscribed at connect.
///
/// This provider does not carry the FeatureVector data itself —
/// InferenceConsumer already does that correctly, updating
/// latestFeatureVectorProvider directly from the general BLE event
/// stream regardless of who's watching it. This provider's only job is
/// the subscribe/unsubscribe side effect, scoped to however long
/// something is actually watching it. autoDispose ensures
/// unsubscribeFeatureVector() fires shortly after the last watcher
/// (the dashboard screen) stops watching, e.g. on navigating away.
final featureVectorSubscriptionProvider = Provider.autoDispose<void>((ref) {
  final bleService = ref.watch(bleServiceProvider);
  bleService.subscribeFeatureVector();
  ref.onDispose(() {
    bleService.unsubscribeFeatureVector();
  });
});
