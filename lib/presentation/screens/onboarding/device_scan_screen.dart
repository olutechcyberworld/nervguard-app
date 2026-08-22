import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../../domain/models/device_state.dart';
import '../../providers/ble_providers.dart';
import '../../providers/device_state_provider.dart';
import '../../providers/onboarding_provider.dart';

class DeviceScanScreen extends ConsumerStatefulWidget {
  const DeviceScanScreen({super.key});

  @override
  ConsumerState<DeviceScanScreen> createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends ConsumerState<DeviceScanScreen> {
  bool _scanning = false;
  bool _advanced = false;

  @override
  void initState() {
    super.initState();
    // Watch for connection and advance once connected + idle.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(deviceStateNotifierProvider, (_, next) async {
        if (_advanced) return;
        if (next.value is Idle) {
          _advanced = true;
          await ref
              .read(onboardingStatusProvider.notifier)
              .advance(OnboardingStep.interventionPool);
          if (mounted) context.go('/onboarding/pool');
        }
      });
    });
  }

  Future<void> _scan() async {
    setState(() => _scanning = true);
    try {
      await ref.read(bleServiceProvider).connect();
    } finally {
      if (mounted) setState(() => _scanning = false);
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
                        : 'Make sure your NervGuard wearable is charged and within range, then tap Scan.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  if (!connected && !_scanning)
                    FilledButton(
                        onPressed: _scan, child: const Text('Scan for Device')),
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
