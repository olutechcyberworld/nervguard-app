sealed class MainMessage {
  const MainMessage();

  Map<String, dynamic> toMap();

  static MainMessage fromMap(Map<String, dynamic> m) {
    return switch (m['t'] as String) {
      'sbc' => SendBleCommand(commandCode: m['cc'] as int),
      'sfv' => const SubscribeFeatureVector(),
      'usfv' => const UnsubscribeFeatureVector(),
      'uip' => UpdateInterventionPool(
          mild: List<String>.from(m['mild'] as List),
          intensive: List<String>.from(m['intensive'] as List),
        ),
      'rcs' => const RequestCalibrationStats(),
      final t => throw StateError('Unknown MainMessage type: $t'),
    };
  }
}

class SendBleCommand extends MainMessage {
  final int commandCode;
  const SendBleCommand({required this.commandCode});

  @override
  Map<String, dynamic> toMap() => {'t': 'sbc', 'cc': commandCode};
}

class SubscribeFeatureVector extends MainMessage {
  const SubscribeFeatureVector();

  @override
  Map<String, dynamic> toMap() => {'t': 'sfv'};
}

class UnsubscribeFeatureVector extends MainMessage {
  const UnsubscribeFeatureVector();

  @override
  Map<String, dynamic> toMap() => {'t': 'usfv'};
}

class UpdateInterventionPool extends MainMessage {
  final List<String> mild;
  final List<String> intensive;
  const UpdateInterventionPool({required this.mild, required this.intensive});

  @override
  Map<String, dynamic> toMap() => {
        't': 'uip',
        'mild': mild,
        'intensive': intensive,
      };
}

/// Main isolate requests a fresh BLE READ of the Calibration Statistics
/// characteristic (A5B30005). The background isolate responds with a
/// CalibrationStatsResult BleMessage.
class RequestCalibrationStats extends MainMessage {
  const RequestCalibrationStats();

  @override
  Map<String, dynamic> toMap() => {'t': 'rcs'};
}
