import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../providers/onboarding_provider.dart';

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen> {
  bool _requesting = false;
  String? _denial;

  Future<void> _requestAll() async {
    setState(() {
      _requesting = true;
      _denial = null;
    });

    final results = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.notification,
    ].request();

    final bleGranted = results[Permission.bluetoothScan]!.isGranted &&
        results[Permission.bluetoothConnect]!.isGranted;

    if (!mounted) return;
    if (!bleGranted) {
      setState(() {
        _requesting = false;
        _denial =
            'Bluetooth permissions are required to connect to your NervGuard device.';
      });
      return;
    }

    await ref
        .read(onboardingStatusProvider.notifier)
        .advance(OnboardingStep.deviceScan);
    if (mounted) context.go('/onboarding/device-scan');
  }

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.bluetooth_searching,
                      color: AppColors.primary, size: 64),
                  const SizedBox(height: 24),
                  Text('Permissions Required',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(
                      'NervGuard needs the following permissions to communicate with your wearable device.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  _PermRow(
                      icon: Icons.bluetooth,
                      label: 'Bluetooth Scan & Connect',
                      description:
                          'Required to find and pair with your wearable.'),
                  const SizedBox(height: 12),
                  _PermRow(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      description:
                          'Delivers stress interventions when the app is in the background.'),
                  if (_denial != null) ...[
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
                              child: Text(_denial!,
                                  style: const TextStyle(
                                      fontSize: 13, color: AppColors.error))),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  _requesting
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton(
                          onPressed: _requestAll,
                          child: const Text('Grant Permissions')),
                  if (_denial != null) ...[
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => openAppSettings(),
                      child: const Text('Open App Settings'),
                    ),
                  ],
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

class _PermRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  const _PermRow(
      {required this.icon, required this.label, required this.description});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 2),
                Text(description,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
