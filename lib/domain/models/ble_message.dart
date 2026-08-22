import 'calibration_stats.dart';
import 'feature_vector.dart';
import 'inference_output.dart';

sealed class BleMessage {
  const BleMessage();

  Map<String, dynamic> toMap();

  static BleMessage fromMap(Map<String, dynamic> m) {
    return switch (m['t'] as String) {
      'dsc' => DeviceStateChanged(
          stateCode: m['sc'] as int,
          auxByte: m['ab'] as int?,
        ),
      'ir' => InferenceReceived(InferenceOutput(
          inferenceClass: m['ic'] as int,
          probability: (m['p'] as num).toDouble(),
          windowSequence: m['ws'] as int,
        )),
      'fvr' => FeatureVectorReceived(FeatureVector(
          windowSequence: m['ws'] as int,
          edaMean: (m['em'] as num).toDouble(),
          edaStd: (m['es'] as num).toDouble(),
          edaSlope: (m['esl'] as num).toDouble(),
          edaRange: (m['er'] as num).toDouble(),
          hrvRmssd: m['hr'] != null ? (m['hr'] as num).toDouble() : null,
          hrvMeanRr: m['hmr'] != null ? (m['hmr'] as num).toDouble() : null,
          hrvSdnn: m['hs'] != null ? (m['hs'] as num).toDouble() : null,
          hrvSd2: m['hd'] != null ? (m['hd'] as num).toDouble() : null,
          hrvAvailable: m['ha'] as bool,
          tempMean: (m['tm'] as num).toDouble(),
          tempSlope: (m['tsl'] as num).toDouble(),
          accMagMean: (m['am'] as num).toDouble(),
          accMagStd: (m['astd'] as num).toDouble(),
          accActivity: m['aa'] as bool,
        )),
      'blc' => BatteryLevelChanged(m['pct'] as int),
      'it' => InterventionTriggered(
          logId: m['lid'] as String,
          intervention: m['iv'] as String,
          tier: m['tier'] as String,
        ),
      'bcsc' => BleConnectionStateChanged(
          connected: m['conn'] as bool,
          gaveUp: m['gu'] as bool? ?? false,
        ),
      'csr' => CalibrationStatsResult(CalibrationStats(
          means: List<double>.from(
              (m['means'] as List).map((e) => (e as num).toDouble())),
          stds: List<double>.from(
              (m['stds'] as List).map((e) => (e as num).toDouble())),
        )),
      final t => throw StateError('Unknown BleMessage type: $t'),
    };
  }
}

class DeviceStateChanged extends BleMessage {
  final int stateCode;
  final int? auxByte;
  const DeviceStateChanged({required this.stateCode, this.auxByte});

  @override
  Map<String, dynamic> toMap() => {'t': 'dsc', 'sc': stateCode, 'ab': auxByte};
}

class InferenceReceived extends BleMessage {
  final InferenceOutput inference;
  const InferenceReceived(this.inference);

  @override
  Map<String, dynamic> toMap() => {
        't': 'ir',
        'ic': inference.inferenceClass,
        'p': inference.probability,
        'ws': inference.windowSequence,
      };
}

class FeatureVectorReceived extends BleMessage {
  final FeatureVector vector;
  const FeatureVectorReceived(this.vector);

  @override
  Map<String, dynamic> toMap() => {
        't': 'fvr',
        'ws': vector.windowSequence,
        'em': vector.edaMean,
        'es': vector.edaStd,
        'esl': vector.edaSlope,
        'er': vector.edaRange,
        'hr': vector.hrvRmssd,
        'hmr': vector.hrvMeanRr,
        'hs': vector.hrvSdnn,
        'hd': vector.hrvSd2,
        'ha': vector.hrvAvailable,
        'tm': vector.tempMean,
        'tsl': vector.tempSlope,
        'am': vector.accMagMean,
        'astd': vector.accMagStd,
        'aa': vector.accActivity,
      };
}

class BatteryLevelChanged extends BleMessage {
  final int percent;
  const BatteryLevelChanged(this.percent);

  @override
  Map<String, dynamic> toMap() => {'t': 'blc', 'pct': percent};
}

class InterventionTriggered extends BleMessage {
  final String logId;
  final String intervention;
  final String tier;
  const InterventionTriggered({
    required this.logId,
    required this.intervention,
    required this.tier,
  });

  @override
  Map<String, dynamic> toMap() => {
        't': 'it',
        'lid': logId,
        'iv': intervention,
        'tier': tier,
      };
}

class BleConnectionStateChanged extends BleMessage {
  final bool connected;
  final bool gaveUp;
  const BleConnectionStateChanged(
      {required this.connected, this.gaveUp = false});

  @override
  Map<String, dynamic> toMap() =>
      {'t': 'bcsc', 'conn': connected, 'gu': gaveUp};
}

class CalibrationStatsResult extends BleMessage {
  final CalibrationStats stats;
  const CalibrationStatsResult(this.stats);

  @override
  Map<String, dynamic> toMap() => {
        't': 'csr',
        'means': stats.means,
        'stds': stats.stds,
      };
}
