import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/models/device_state.dart';
import '../../providers/ble_providers.dart';
import '../../providers/device_state_provider.dart';

class DevicePairingScreen extends ConsumerStatefulWidget {
  const DevicePairingScreen({super.key});

  @override
  ConsumerState<DevicePairingScreen> createState() =>
      _DevicePairingScreenState();
}

class _DevicePairingScreenState extends ConsumerState<DevicePairingScreen> {
  bool _connecting = false;

  Future<void> _connect() async {
    setState(() => _connecting = true);
    try {
      await ref.read(bleServiceProvider).connect();
    } finally {
      if (mounted) setState(() => _connecting = false);
    }
  }

  Future<void> _disconnect() async {
    final notifier = ref.read(deviceStateNotifierProvider.notifier);
    if (ref.read(deviceStateNotifierProvider).value is Monitoring) {
      await notifier.stopMonitoring();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connected = ref.watch(bleConnectionProvider).value ?? false;
    final deviceState = ref.watch(deviceStateNotifierProvider).value;

    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: const Text('Device Pairing')),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlassCard(
                      child: Column(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              connected
                                  ? Icons.watch
                                  : Icons.watch_off_outlined,
                              size: 64,
                              color: connected
                                  ? AppColors.stressLow
                                  : AppColors.fontSecondary,
                              key: ValueKey(connected),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            connected
                                ? 'NervGuard Wearable'
                                : 'No Device Connected',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            connected
                                ? 'State: ${_stateLabel(deviceState)}'
                                : 'Search for your NervGuard device to connect.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_connecting)
                      const Center(child: CircularProgressIndicator())
                    else if (!connected)
                      FilledButton.icon(
                        onPressed: _connect,
                        icon: const Icon(Icons.bluetooth_searching),
                        label: const Text('Scan & Connect'),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: _disconnect,
                        icon: const Icon(Icons.bluetooth_disabled),
                        label: const Text('Disconnect'),
                        style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error)),
                      ),
                    const SizedBox(height: 16),
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pairing Instructions',
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 12),
                          _Step(
                              n: '1',
                              label: 'Charge your NervGuard wearable fully.'),
                          _Step(
                              n: '2',
                              label:
                                  'Keep the device within 1 metre of your phone.'),
                          _Step(
                              n: '3',
                              label:
                                  'Tap Scan & Connect and wait for pairing.'),
                          _Step(
                              n: '4',
                              label:
                                  'If prompted, confirm the pairing on your phone.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _stateLabel(DeviceState? state) => switch (state) {
        Monitoring() => 'Monitoring',
        Calibrating(:final progress) => 'Calibrating ($progress%)',
        NotWorn() => 'Not Worn',
        Idle() => 'Idle',
        Uncalibrated() => 'Uncalibrated',
        DeviceErrorState(:final error) => 'Error: ${error.name}',
        PendingReset() => 'Pending Reset',
        _ => 'Unknown',
      };
}

class _Step extends StatelessWidget {
  final String n;
  final String label;
  const _Step({required this.n, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: Center(
                child: Text(n,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700))),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
