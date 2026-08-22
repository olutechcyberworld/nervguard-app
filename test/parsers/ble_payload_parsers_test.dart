import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:nervguard/background/ble_payload_parsers.dart';

List<int> _float32LEBytes(double value) {
  final byteData = ByteData(4)..setFloat32(0, value, Endian.little);
  return List<int>.generate(4, (i) => byteData.getUint8(i));
}

void main() {
  group('parseDeviceState', () {
    test('decodes single-byte states with no aux byte', () {
      for (final code in [0x00, 0x01, 0x03, 0x04, 0x06]) {
        final result = parseDeviceState([code]);
        expect(result.stateCode, code);
        expect(result.auxByte, isNull);
      }
    });

    test('decodes CALIBRATING with progress 0', () {
      final result = parseDeviceState([0x02, 0]);
      expect(result.stateCode, 0x02);
      expect(result.auxByte, 0);
    });

    test('decodes CALIBRATING with progress 100', () {
      final result = parseDeviceState([0x02, 100]);
      expect(result.stateCode, 0x02);
      expect(result.auxByte, 100);
    });

    test('decodes ERROR with error code', () {
      final result = parseDeviceState([0x05, 0x04]);
      expect(result.stateCode, 0x05);
      expect(result.auxByte, 0x04);
    });

    test('throws on empty payload', () {
      expect(() => parseDeviceState([]), throwsArgumentError);
    });
  });

  group('parseInference', () {
    test('decodes probability 0x00 as 0.0', () {
      final result = parseInference([0x00, 0x00, 0]);
      expect(result.inferenceClass, 0);
      expect(result.probability, 0.0);
      expect(result.windowSequence, 0);
    });

    test('decodes probability 0xFF as 1.0', () {
      final result = parseInference([0x02, 0xFF, 255]);
      expect(result.inferenceClass, 2);
      expect(result.probability, 1.0);
      expect(result.windowSequence, 255);
    });

    test('throws on incorrect payload length', () {
      expect(() => parseInference([0x00, 0x00]), throwsArgumentError);
    });
  });

  group('parseFeatureVector', () {
    List<int> buildPayload({
      required int windowSequence,
      required double hrvRmssd,
      required bool accActivity,
    }) {
      final bytes = <int>[windowSequence];
      final values = [
        0.5, 0.1, 0.02, 1.2, // eda
        hrvRmssd, 800.0, 40.0, 60.0, // hrv
        32.5, -0.01, // temp
        0.99, 0.01, accActivity ? 1.0 : 0.0, // acc
      ];
      for (final v in values) {
        bytes.addAll(_float32LEBytes(v));
      }
      return bytes;
    }

    test('decodes window sequence and fields when HRV is available', () {
      final payload =
          buildPayload(windowSequence: 42, hrvRmssd: 35.0, accActivity: false);
      final result = parseFeatureVector(payload);
      expect(result.windowSequence, 42);
      expect(result.hrvAvailable, isTrue);
      expect(result.hrvRmssd, closeTo(35.0, 1e-4));
      expect(result.accActivity, isFalse);
    });

    test('maps all four HRV fields to null on -1.0f sentinel', () {
      final payload =
          buildPayload(windowSequence: 7, hrvRmssd: -1.0, accActivity: true);
      final result = parseFeatureVector(payload);
      expect(result.hrvAvailable, isFalse);
      expect(result.hrvRmssd, isNull);
      expect(result.hrvMeanRr, isNull);
      expect(result.hrvSdnn, isNull);
      expect(result.hrvSd2, isNull);
      expect(result.accActivity, isTrue);
    });

    test('throws on incorrect payload length', () {
      expect(() => parseFeatureVector(List.filled(52, 0)), throwsArgumentError);
    });
  });

  group('parseCalibrationStats', () {
    test('round-trips 13 means and 13 stds at float32 precision', () {
      final means = List<double>.generate(13, (i) => i * 1.1);
      final stds = List<double>.generate(13, (i) => i * 0.5 + 0.1);
      final bytes = <int>[
        for (final m in means) ..._float32LEBytes(m),
        for (final s in stds) ..._float32LEBytes(s),
      ];
      final result = parseCalibrationStats(bytes);
      for (var i = 0; i < 13; i++) {
        expect(result.means[i], closeTo(means[i], 1e-5));
        expect(result.stds[i], closeTo(stds[i], 1e-5));
      }
    });

    test('throws on incorrect payload length', () {
      expect(() => parseCalibrationStats(List.filled(100, 0)),
          throwsArgumentError);
    });
  });

  group('parseBatteryLevel', () {
    test('decodes valid percentage', () {
      expect(parseBatteryLevel([73]), 73);
    });

    test('throws on out-of-range percentage', () {
      expect(() => parseBatteryLevel([101]), throwsArgumentError);
    });

    test('throws on incorrect payload length', () {
      expect(() => parseBatteryLevel([1, 2]), throwsArgumentError);
    });
  });
}
