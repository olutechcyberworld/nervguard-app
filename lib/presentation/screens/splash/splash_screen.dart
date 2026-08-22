import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/glass_widgets.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/preferences/app_preferences.dart';
import '../../providers/onboarding_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final step = await ref.read(onboardingStatusProvider.future);
    if (!mounted) return;
    if (step == OnboardingStep.complete) {
      context.go('/home/dashboard');
    } else {
      context.go(_stepRoute(step));
    }
  }

  String _stepRoute(OnboardingStep step) => switch (step) {
        OnboardingStep.welcome => '/onboarding/welcome',
        OnboardingStep.account => '/onboarding/account',
        OnboardingStep.permissions => '/onboarding/permissions',
        OnboardingStep.deviceScan => '/onboarding/device-scan',
        OnboardingStep.interventionPool => '/onboarding/pool',
        OnboardingStep.calibration => '/onboarding/calibration',
        OnboardingStep.complete => '/home/dashboard',
      };

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/app_icon/app_icon.png',
                      width: 96,
                      height: 96,
                      errorBuilder: (_, __, ___) => Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.2),
                              border: Border.all(
                                  color: AppColors.primary, width: 2),
                            ),
                            child: const Icon(Icons.monitor_heart,
                                color: AppColors.primary, size: 48),
                          )),
                  const SizedBox(height: 24),
                  Text('NervGuard',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 8),
                  Text('Autonomic Stress Detection',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
