import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/domain/models/feature_vector.dart';
import 'package:nervguard/domain/models/inference_output.dart';
import 'package:nervguard/presentation/providers/inference_providers.dart';

FeatureVector _fv(int seq) => FeatureVector(
      windowSequence: seq,
      edaMean: 1,
      edaStd: 1,
      edaSlope: 0,
      edaRange: 1,
      hrvRmssd: 1,
      hrvMeanRr: 1,
      hrvSdnn: 1,
      hrvSd2: 1,
      hrvAvailable: true,
      tempMean: 1,
      tempSlope: 0,
      accMagMean: 1,
      accMagStd: 0,
      accActivity: false,
    );

InferenceOutput _inf(int seq) =>
    InferenceOutput(inferenceClass: 0, probability: 0.1, windowSequence: seq);

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('null when only inference is set', () {
    container.read(latestInferenceProvider.notifier).state = _inf(10);
    expect(container.read(correlatedWindowProvider), isNull);
  });

  test('correlates when sequences match exactly', () {
    container.read(latestInferenceProvider.notifier).state = _inf(10);
    container.read(latestFeatureVectorProvider.notifier).state = _fv(10);
    expect(container.read(correlatedWindowProvider), isNotNull);
  });

  test('correlates within jitter tolerance of 5', () {
    container.read(latestInferenceProvider.notifier).state = _inf(10);
    container.read(latestFeatureVectorProvider.notifier).state = _fv(15);
    expect(container.read(correlatedWindowProvider), isNotNull);
  });

  test('does not correlate beyond jitter tolerance of 5', () {
    container.read(latestInferenceProvider.notifier).state = _inf(10);
    container.read(latestFeatureVectorProvider.notifier).state = _fv(16);
    expect(container.read(correlatedWindowProvider), isNull);
  });

  test('correlates across the mod-256 wraparound boundary', () {
    // 254 -> 255 -> 0 -> 1 -> 2 is 4 steps, within tolerance.
    container.read(latestInferenceProvider.notifier).state = _inf(254);
    container.read(latestFeatureVectorProvider.notifier).state = _fv(2);
    expect(container.read(correlatedWindowProvider), isNotNull);
  });

  test('does not correlate when wraparound distance exceeds tolerance', () {
    // 250 -> 255 -> 0 -> 1 -> 2 is 8 steps, beyond tolerance.
    container.read(latestInferenceProvider.notifier).state = _inf(250);
    container.read(latestFeatureVectorProvider.notifier).state = _fv(2);
    expect(container.read(correlatedWindowProvider), isNull);
  });
}
