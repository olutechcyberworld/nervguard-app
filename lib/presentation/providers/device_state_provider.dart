import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/ble_constants.dart';
import '../../domain/models/ble_message.dart';
import '../../domain/models/device_state.dart';
import 'ble_providers.dart';
import 'calibration_stats_provider.dart';

class DeviceStateNotifier extends AsyncNotifier<DeviceState> {
  StreamSubscription<BleMessage>? _subscription;

  @override
  Future<DeviceState> build() async {
    final bleService = ref.watch(bleServiceProvider);
    _subscription?.cancel();
    _subscription = bleService.events
        .where((message) => message is DeviceStateChanged)
        .cast<DeviceStateChanged>()
        .listen(_onDeviceStateChanged);
    ref.onDispose(() => _subscription?.cancel());

    return const Uncalibrated();
  }

  void _onDeviceStateChanged(DeviceStateChanged event) {
    final previous = state.value;
    final next = _mapToDeviceState(event, previous);
    state = AsyncData(next);

    if (previous is Calibrating && next is Idle) {
      // Fire-and-forget: refresh() manages its own AsyncLoading/AsyncData
      // lifecycle independently on calibrationStatsNotifierProvider. Not
      // awaited here since this is a synchronous stream listener
      // callback; the BLE GATT contract requires re-reading calibration
      // statistics after every CALIBRATING -> IDLE transition specifically,
      // not after Idle is reached by any other path (e.g. stopMonitoring
      // from MONITORING does not warrant a recalibration re-read).
      ref.read(calibrationStatsNotifierProvider.notifier).refresh();
    }
  }

  DeviceState _mapToDeviceState(
      DeviceStateChanged event, DeviceState? previous) {
    switch (event.stateCode) {
      case BleConstants.stateUncalibrated:
        return const Uncalibrated();
      case BleConstants.stateIdle:
        return const Idle();
      case BleConstants.stateNotWorn:
        return const NotWorn();
      case BleConstants.stateMonitoring:
        return const Monitoring();
      case BleConstants.stateCalibrating:
        return Calibrating(progress: event.auxByte ?? 0);
      case BleConstants.stateError:
        return DeviceErrorState(error: _mapErrorCode(event.auxByte));
      case BleConstants.statePendingReset:
        return PendingReset(previousState: previous ?? const Uncalibrated());
      default:
        throw StateError(
            'Unrecognised device state code: 0x${event.stateCode.toRadixString(16)}');
    }
  }

  DeviceError _mapErrorCode(int? code) {
    switch (code) {
      case BleConstants.errI2cBusFailure:
        return DeviceError.i2cBusFailure;
      case BleConstants.errOneWireFailure:
        return DeviceError.oneWireFailure;
      case BleConstants.errEdaAdcFailure:
        return DeviceError.edaAdcFailure;
      case BleConstants.errTfliteAllocFailure:
        return DeviceError.tfliteAllocFailure;
      case BleConstants.errNvsFailure:
        return DeviceError.nvsFailure;
      case BleConstants.errPersistentSignal:
        return DeviceError.persistentSignal;
      default:
        return DeviceError.unknown;
    }
  }

  bool get canStartCalibration => switch (state.value) {
        Uncalibrated() || Idle() => true,
        _ => false,
      };

  bool get canStartMonitoring => state.value is Idle;

  bool get canStopMonitoring => switch (state.value) {
        Monitoring() || NotWorn() => true,
        _ => false,
      };

  bool get canRequestReset => switch (state.value) {
        null || PendingReset() => false,
        _ => true,
      };

  bool get canConfirmReset => state.value is PendingReset;

  Future<void> startCalibration() async {
    if (!canStartCalibration) {
      throw StateError(
          'startCalibration called from invalid state: ${state.value}');
    }
    state = const AsyncLoading();
    await ref
        .read(bleServiceProvider)
        .sendCommand(BleConstants.cmdStartCalibration);
  }

  Future<void> startMonitoring() async {
    if (!canStartMonitoring) {
      throw StateError(
          'startMonitoring called from invalid state: ${state.value}');
    }
    state = const AsyncLoading();
    await ref
        .read(bleServiceProvider)
        .sendCommand(BleConstants.cmdStartIntervention);
  }

  Future<void> stopMonitoring() async {
    if (!canStopMonitoring) {
      throw StateError(
          'stopMonitoring called from invalid state: ${state.value}');
    }
    state = const AsyncLoading();
    await ref
        .read(bleServiceProvider)
        .sendCommand(BleConstants.cmdStopIntervention);
  }

  Future<void> requestReset() async {
    if (!canRequestReset) {
      throw StateError(
          'requestReset called from invalid state: ${state.value}');
    }
    await ref
        .read(bleServiceProvider)
        .sendCommand(BleConstants.cmdRequestReset);
  }

  Future<void> confirmReset() async {
    if (!canConfirmReset) {
      throw StateError(
          'confirmReset called from invalid state: ${state.value}');
    }
    await ref
        .read(bleServiceProvider)
        .sendCommand(BleConstants.cmdConfirmReset);
  }
}

final deviceStateNotifierProvider =
    AsyncNotifierProvider<DeviceStateNotifier, DeviceState>(
        DeviceStateNotifier.new);
