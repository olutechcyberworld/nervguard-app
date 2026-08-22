import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/device_state.dart';
import 'device_state_provider.dart';

class WarmupActiveNotifier extends Notifier<bool> {
  Timer? _timer;
  bool _wasMonitoring = false;

  @override
  bool build() {
    ref.listen<AsyncValue<DeviceState>>(deviceStateNotifierProvider,
        (previous, next) {
      final isMonitoring = next.value is Monitoring;
      if (isMonitoring && !_wasMonitoring) {
        activate();
      }
      _wasMonitoring = isMonitoring;
    });
    ref.onDispose(() => _timer?.cancel());
    return false;
  }

  void activate() {
    _timer?.cancel();
    state = true;
    _timer = Timer(const Duration(seconds: 65), deactivate);
  }

  void deactivate() {
    _timer?.cancel();
    _timer = null;
    state = false;
  }
}

final warmupActiveProvider = NotifierProvider<WarmupActiveNotifier, bool>(
  WarmupActiveNotifier.new,
);

class ResetCountdownNotifier extends Notifier<int> {
  static const _countdownStart = 15;

  Timer? _ticker;
  bool _wasPendingReset = false;

  @override
  int build() {
    ref.listen<AsyncValue<DeviceState>>(deviceStateNotifierProvider,
        (previous, next) {
      final isPendingReset = next.value is PendingReset;
      if (isPendingReset && !_wasPendingReset) {
        _start();
      } else if (!isPendingReset && _wasPendingReset) {
        _reset();
      }
      _wasPendingReset = isPendingReset;
    });
    ref.onDispose(() => _ticker?.cancel());
    return _countdownStart;
  }

  void _start() {
    _ticker?.cancel();
    state = _countdownStart;
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state <= 0) {
        timer.cancel();
        return;
      }
      state = state - 1;
    });
  }

  void _reset() {
    _ticker?.cancel();
    _ticker = null;
    state = _countdownStart;
  }
}

final resetCountdownProvider = NotifierProvider<ResetCountdownNotifier, int>(
  ResetCountdownNotifier.new,
);
