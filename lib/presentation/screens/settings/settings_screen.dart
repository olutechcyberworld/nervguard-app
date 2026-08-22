import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/models/device_state.dart';
import '../../providers/device_state_provider.dart';
import '../../providers/ble_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceState = ref.watch(deviceStateNotifierProvider).value;
    final connected = ref.watch(bleConnectionProvider).value ?? false;

    return GlassBackground(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 24),
            _Section(label: 'Device', children: [
              _SettingsTile(
                icon: Icons.bluetooth,
                title: 'Device Pairing',
                subtitle: connected ? 'Connected' : 'Not connected',
                trailing:
                    Icon(Icons.chevron_right, color: AppColors.fontSecondary),
                onTap: () => context.push('/settings/device-pairing'),
              ),
              if (connected &&
                  (deviceState is Monitoring || deviceState is NotWorn))
                _SettingsTile(
                  icon: Icons.stop_circle_outlined,
                  title: 'Stop Monitoring',
                  subtitle: 'End the current monitoring session',
                  onTap: () => ref
                      .read(deviceStateNotifierProvider.notifier)
                      .stopMonitoring(),
                ),
              if (connected && deviceState is Idle)
                _SettingsTile(
                  icon: Icons.play_circle_outline,
                  title: 'Start Monitoring',
                  subtitle: 'Begin stress detection',
                  onTap: () => ref
                      .read(deviceStateNotifierProvider.notifier)
                      .startMonitoring(),
                ),
            ]),
            const SizedBox(height: 16),
            _Section(label: 'Calibration', children: [
              if (connected &&
                  (deviceState is Idle || deviceState is Uncalibrated))
                _SettingsTile(
                  icon: Icons.tune,
                  title: 'Recalibrate',
                  subtitle: 'Collect a new personal baseline',
                  onTap: () => ref
                      .read(deviceStateNotifierProvider.notifier)
                      .startCalibration(),
                ),
              if (connected)
                _SettingsTile(
                  icon: Icons.restart_alt,
                  title: 'Reset Calibration',
                  subtitle: 'Clear all stored calibration data',
                  iconColor: AppColors.error,
                  onTap: () => _confirmReset(context, ref),
                ),
            ]),
            const SizedBox(height: 16),
            _Section(label: 'App', children: [
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About NervGuard',
                subtitle: 'Version, developer info, tech stack',
                trailing:
                    Icon(Icons.chevron_right, color: AppColors.fontSecondary),
                onTap: () => context.push('/settings/about'),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Reset Calibration?'),
        content: const Text(
            'This will delete your personal baseline. You will need to recalibrate before monitoring can resume.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Reset', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(deviceStateNotifierProvider.notifier).requestReset();
    }
  }
}

class _Section extends StatelessWidget {
  final String label;
  final List<Widget> children;
  const _Section({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fontSecondary)),
        ),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: children.map((child) {
              final isLast = child == children.last;
              return Column(
                children: [
                  child,
                  if (!isLast) Divider(height: 1, color: AppColors.glassBorder),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color iconColor;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(title, style: Theme.of(context).textTheme.labelLarge),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
