/// Raw wire-level representation of the Device State characteristic
/// (A5B30001), decoded directly from its byte payload with no
/// interpretation applied. The richer DeviceState sealed hierarchy
/// (Phase 3.4 of the app architecture handoff) consumes this packet
/// but is built in Sprint 2 against DeviceStateNotifier. This file's
/// Sprint 1 scope is limited to the pure parse step.
class DeviceStatePacket {
  final int stateCode; // 0x00-0x06
  final int?
      auxByte; // progress (CALIBRATING) or error code (ERROR); null otherwise

  const DeviceStatePacket({required this.stateCode, this.auxByte});

  @override
  bool operator ==(Object other) =>
      other is DeviceStatePacket &&
      other.stateCode == stateCode &&
      other.auxByte == auxByte;

  @override
  int get hashCode => Object.hash(stateCode, auxByte);

  @override
  String toString() =>
      'DeviceStatePacket(stateCode: 0x${stateCode.toRadixString(16).padLeft(2, '0')}, auxByte: $auxByte)';
}

// ... DeviceStatePacket class from Sprint 1 remains unchanged above ...

sealed class DeviceState {
  const DeviceState();
}

class Uncalibrated extends DeviceState {
  const Uncalibrated();
}

class Idle extends DeviceState {
  const Idle();
}

class NotWorn extends DeviceState {
  const NotWorn();
}

class Monitoring extends DeviceState {
  const Monitoring();
}

class Calibrating extends DeviceState {
  final int progress; // 0-100, from CALIBRATING state byte 1
  const Calibrating({required this.progress});
}

class DeviceErrorState extends DeviceState {
  final DeviceError error;
  const DeviceErrorState({required this.error});
}

class PendingReset extends DeviceState {
  final DeviceState
      previousState; // captured before transition, used if timeout occurs
  const PendingReset({required this.previousState});
}

enum DeviceError {
  i2cBusFailure,
  oneWireFailure,
  edaAdcFailure,
  tfliteAllocFailure,
  nvsFailure,
  persistentSignal,
  unknown,
}
