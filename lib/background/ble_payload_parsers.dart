import 'dart:typed_data';

import '../domain/models/calibration_stats.dart';
import '../domain/models/device_state.dart';
import '../domain/models/feature_vector.dart';
import '../domain/models/inference_output.dart';

const int _featureVectorByteLength = 53;
const int _calibrationStatsByteLength = 104;

double _readFloat32LE(List<int> bytes, int offset) {
  final byteData = ByteData(4);
  for (var i = 0; i < 4; i++) {
    byteData.setUint8(i, bytes[offset + i]);
  }
  return byteData.getFloat32(0, Endian.little);
}

/// Decodes the Device State characteristic (A5B30001) payload. Byte 0
/// is always the state code. Byte 1 is present only for CALIBRATING
/// (progress 0-100) and ERROR (error code); absent for all other
/// states, per the locked GATT contract.
DeviceStatePacket parseDeviceState(List<int> bytes) {
  if (bytes.isEmpty) {
    throw ArgumentError(
        'Device State payload must contain at least 1 byte, got ${bytes.length}');
  }
  return DeviceStatePacket(
    stateCode: bytes[0],
    auxByte: bytes.length >= 2 ? bytes[1] : null,
  );
}

/// Decodes the Inference Output characteristic (A5B30003) payload.
/// Probability is dequantized from uint8 (0x00 = 0.0, 0xFF = 1.0) by
/// linear mapping across the full byte range.
InferenceOutput parseInference(List<int> bytes) {
  if (bytes.length != 3) {
    throw ArgumentError(
        'Inference Output payload must be exactly 3 bytes, got ${bytes.length}');
  }
  return InferenceOutput(
    inferenceClass: bytes[0],
    probability: bytes[1] / 255.0,
    windowSequence: bytes[2],
  );
}

/// Decodes the Feature Vector characteristic (A5B30004) payload: 53
/// bytes, 1 sequence byte followed by 13 little-endian float32 values
/// in the order locked by the BLE GATT contract. If hrv_rmssd decodes
/// to the -1.0f sentinel, all four HRV fields are mapped to null and
/// hrvAvailable is set to false.
FeatureVector parseFeatureVector(List<int> bytes) {
  if (bytes.length != _featureVectorByteLength) {
    throw ArgumentError(
        'Feature Vector payload must be exactly $_featureVectorByteLength bytes, got ${bytes.length}');
  }

  final windowSequence = bytes[0];

  final edaMean = _readFloat32LE(bytes, 1);
  final edaStd = _readFloat32LE(bytes, 5);
  final edaSlope = _readFloat32LE(bytes, 9);
  final edaRange = _readFloat32LE(bytes, 13);

  final rawHrvRmssd = _readFloat32LE(bytes, 17);
  final rawHrvMeanRr = _readFloat32LE(bytes, 21);
  final rawHrvSdnn = _readFloat32LE(bytes, 25);
  final rawHrvSd2 = _readFloat32LE(bytes, 29);

  final tempMean = _readFloat32LE(bytes, 33);
  final tempSlope = _readFloat32LE(bytes, 37);

  final accMagMean = _readFloat32LE(bytes, 41);
  final accMagStd = _readFloat32LE(bytes, 45);
  final accActivityRaw = _readFloat32LE(bytes, 49);

  final hrvAvailable = rawHrvRmssd != -1.0;

  return FeatureVector(
    windowSequence: windowSequence,
    edaMean: edaMean,
    edaStd: edaStd,
    edaSlope: edaSlope,
    edaRange: edaRange,
    hrvRmssd: hrvAvailable ? rawHrvRmssd : null,
    hrvMeanRr: hrvAvailable ? rawHrvMeanRr : null,
    hrvSdnn: hrvAvailable ? rawHrvSdnn : null,
    hrvSd2: hrvAvailable ? rawHrvSd2 : null,
    hrvAvailable: hrvAvailable,
    tempMean: tempMean,
    tempSlope: tempSlope,
    accMagMean: accMagMean,
    accMagStd: accMagStd,
    accActivity: accActivityRaw != 0.0,
  );
}

/// Decodes the Calibration Statistics characteristic (A5B30005)
/// payload: 104 bytes, 13 little-endian float32 means followed by 13
/// little-endian float32 standard deviations, in Feature Vector order.
CalibrationStats parseCalibrationStats(List<int> bytes) {
  if (bytes.length != _calibrationStatsByteLength) {
    throw ArgumentError(
        'Calibration Statistics payload must be exactly $_calibrationStatsByteLength bytes, got ${bytes.length}');
  }

  final means = List<double>.generate(13, (i) => _readFloat32LE(bytes, i * 4));
  final stds =
      List<double>.generate(13, (i) => _readFloat32LE(bytes, 52 + i * 4));

  return CalibrationStats(means: means, stds: stds);
}

/// Decodes the Battery Level characteristic (0x2A19) payload.
int parseBatteryLevel(List<int> bytes) {
  if (bytes.length != 1) {
    throw ArgumentError(
        'Battery Level payload must be exactly 1 byte, got ${bytes.length}');
  }
  final percent = bytes[0];
  if (percent > 100) {
    throw ArgumentError('Battery Level percent must be 0-100, got $percent');
  }
  return percent;
}
