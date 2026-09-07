import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../providers/ble_providers.dart';
import '../../providers/onboarding_provider.dart';

class DeviceScanScreen extends ConsumerStatefulWidget {
  const DeviceScanScreen({super.key});

  @override
  ConsumerState<DeviceScanScreen> createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends ConsumerState<DeviceScanScreen> {
  bool _scanning = false;
  bool _advanced = false;
  bool _gaveUp = false;

  @override
  void initState() {
    super.initState();
    // BUG FIX: this previously advanced only when deviceStateNotifierProvider
    // reached Idle, but Idle is a POST-calibration state. A first-time
    // device's very first successful connection lands in Uncalibrated,
    // never Idle, so this could never fire for exactly the scenario that
    // matters most — initial pairing with a fresh device. Per the locked
    // architecture doc, Step 4 (Device Scan) completes on connection
    // alone; Idle only becomes relevant at Step 6 (Calibration), several
    // steps later. Advancing on bleConnectionProvider directly matches
    // that spec instead of silently requiring calibration to already be
    // done before the user can even reach the calibration screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(bleConnectionProvider, (_, next) async {
        if (_advanced) return;
        if (next.value == true) {
          _advanced = true;
          await ref
              .read(onboardingStatusProvider.notifier)
              .advance(OnboardingStep.interventionPool);
          if (mounted) context.go('/onboarding/pool');
        }
      });

      // BUG FIX: previously nothing in this screen listened for the
      // "gave up after 10 reconnect attempts" signal at all. _scan()
      // below only awaits the Android foreground service starting, not
      // the actual BLE connection outcome, so without this listener the
      // UI has no way to ever show a failure — it just sits on
      // "Scanning…" briefly, then silently returns to the idle button
      // with no explanation, indistinguishable from having never tried.
      ref.listenManual(bleConnectionGaveUpProvider, (_, next) {
        if (next.value == true && mounted) {
          setState(() {
            _scanning = false;
            _gaveUp = true;
          });
        }
      });
    });
  }

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _gaveUp = false;
    });
    try {
      // NOTE: this only awaits the Android foreground service starting,
      // not the underlying BLE connection — the real connection attempt
      // (scan -> GATT connect -> ... -> bonded) runs asynchronously in
      // the background isolate afterwards and reports its own outcome
      // via bleConnectionProvider / bleConnectionGaveUpProvider above.
      // _scanning is intentionally left true here rather than cleared
      // in a finally block; it is cleared either by a successful
      // connection (bleConnectionProvider flips true, "connected"
      // branch renders) or by bleConnectionGaveUpProvider above.
      await ref.read(bleServiceProvider).connect();
    } catch (e, st) {
      // See the same correction note in foreground_task_handler.dart:
      // print(), not developer.log(), is what reliably reaches logcat
      // in a normally-launched (non-attached) build.
      // ignore: avoid_print
      print('[NervGuard.BLE.UI] connect() call itself threw: $e\n$st');
      if (mounted) {
        setState(() {
          _scanning = false;
          _gaveUp = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(bleConnectionProvider).value ?? false;

    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: connected
                        ? const Icon(Icons.bluetooth_connected,
                            color: AppColors.stressLow,
                            size: 72,
                            key: ValueKey('conn'))
                        : _scanning
                            ? SizedBox(
                                width: 72,
                                height: 72,
                                key: const ValueKey('scan'),
                                child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: AppColors.primary
                                        .withValues(alpha: 0.7)),
                              )
                            : const Icon(Icons.bluetooth_searching,
                                color: AppColors.primary,
                                size: 72,
                                key: ValueKey('idle')),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    connected
                        ? 'Device Connected'
                        : _scanning
                            ? 'Scanning…'
                            : 'Find Your Device',
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    connected
                        ? 'NervGuard wearable found and connected. Setting up your experience…'
                        : _gaveUp
                            ? 'Could not connect after several attempts.'
                            : 'Make sure your NervGuard wearable is charged and within range, then tap Scan.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (_gaveUp && !connected) ...[
                    const SizedBox(height: 16),
                    GlassCard(
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      borderColor: AppColors.error.withValues(alpha: 0.4),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: AppColors.error),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Check that the wearable is powered on and in '
                              'range, then try again. If this keeps '
                              'happening, an engineer should check the '
                              'device logs (adb logcat, filter '
                              '"NervGuard.BLE") for the specific failure.',
                              style: const TextStyle(
                                  fontSize: 13, color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (!connected && !_scanning)
                    FilledButton(
                        onPressed: _scan,
                        child: Text(_gaveUp ? 'Try Again' : 'Scan for Device')),
                  if (connected)
                    GlassCard(
                      backgroundColor:
                          AppColors.stressLow.withValues(alpha: 0.1),
                      borderColor: AppColors.stressLow.withValues(alpha: 0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.stressLow),
                          const SizedBox(width: 8),
                          Text('Connected — proceeding…',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: AppColors.stressLow)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
