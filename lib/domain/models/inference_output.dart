/// Decoded payload of the Inference Output characteristic (A5B30003).
class InferenceOutput {
  final int inferenceClass; // 0, 1, or 2
  final double probability; // dequantized 0.0-1.0
  final int windowSequence; // rolling 0-255

  const InferenceOutput({
    required this.inferenceClass,
    required this.probability,
    required this.windowSequence,
  });

  @override
  bool operator ==(Object other) =>
      other is InferenceOutput &&
      other.inferenceClass == inferenceClass &&
      other.probability == probability &&
      other.windowSequence == windowSequence;

  @override
  int get hashCode => Object.hash(inferenceClass, probability, windowSequence);

  @override
  String toString() =>
      'InferenceOutput(class: $inferenceClass, probability: $probability, seq: $windowSequence)';
}
