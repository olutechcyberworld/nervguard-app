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
      'rrc' => const RequestReconnect(),
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

/// Tells an ALREADY-RUNNING background isolate to attempt a fresh
/// connection right now, resetting any exhausted reconnect backoff.
///
/// BUG FIX: this exists because FlutterForegroundTask.startService()
/// throws internally, and returns ServiceRequestFailure rather than
/// succeeding, whenever the service is already running — which
/// RealBleService.connect() was silently discarding. Confirmed cause on
/// real hardware: the peripheral was powered off overnight, the
/// background isolate's own _scheduleReconnect() backoff loop exhausted
/// all 10 attempts and gave up, but giving up does not stop the
/// foreground service itself, so it stayed alive with
/// FlutterForegroundTask.isRunningService still true. The next morning,
/// tapping "Connect Device" called startService() again, which
/// correctly detected the service was already running, failed
/// internally, and RealBleService.connect() ignored that failure
/// entirely — producing a button that appeared to do nothing.
/// startService() is only valid for a genuine first start; reconnecting
/// an already-running, already-given-up isolate needs a message sent
/// INTO that isolate instead, which is what this is for.
class RequestReconnect extends MainMessage {
  const RequestReconnect();

  @override
  Map<String, dynamic> toMap() => {'t': 'rrc'};
}
