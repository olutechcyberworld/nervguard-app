import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../providers/onboarding_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset('assets/app_icon/app_icon.png',
                      width: 80,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.monitor_heart,
                          color: AppColors.primary,
                          size: 80)),
                  const SizedBox(height: 32),
                  Text('Welcome to NervGuard',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(
                    'Your personal autonomic stress detection platform. '
                    'NervGuard monitors your physiological signals in real-time '
                    'and delivers personalised interventions when stress is detected.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  _FeatureRow(
                      icon: Icons.sensors,
                      label: 'Real-time EDA, HRV & temperature monitoring'),
                  const SizedBox(height: 12),
                  _FeatureRow(
                      icon: Icons.psychology_outlined,
                      label: 'On-device stress classification'),
                  const SizedBox(height: 12),
                  _FeatureRow(
                      icon: Icons.self_improvement,
                      label: 'Personalised iCBT interventions'),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      await ref
                          .read(onboardingStatusProvider.notifier)
                          .advance(OnboardingStep.account);
                      if (context.mounted) context.go('/onboarding/account');
                    },
                    child: const Text('Get Started'),
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

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
              child:
                  Text(label, style: Theme.of(context).textTheme.labelLarge)),
        ],
      ),
    );
  }
}
