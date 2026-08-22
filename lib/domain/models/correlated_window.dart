import 'feature_vector.dart';
import 'inference_output.dart';

/// A single window's inference and physiological data, assembled only
/// when both arrive with matching (within jitter tolerance) window
/// sequence numbers, per the Window Sequence Correlation rule in
/// Phase 3.3.
class CorrelatedWindow {
  final InferenceOutput inference;
  final FeatureVector featureVector;

  const CorrelatedWindow(
      {required this.inference, required this.featureVector});
}
