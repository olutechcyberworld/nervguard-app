// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/preferences/app_preferences.dart';
import '../providers/onboarding_provider.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/onboarding/account_screen.dart';
import '../screens/onboarding/calibration_screen.dart';
import '../screens/onboarding/device_scan_screen.dart';
import '../screens/onboarding/intervention_pool_screen.dart';
import '../screens/onboarding/permissions_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/device_pairing_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/shell/app_shell.dart';
import '../screens/splash/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  GoRouter? router;
  ref.listen(onboardingStatusProvider, (_, __) => router?.refresh());

  router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(
          path: '/onboarding/welcome',
          builder: (_, __) => const WelcomeScreen()),
      GoRoute(
          path: '/onboarding/account',
          builder: (_, __) => const AccountScreen()),
      GoRoute(
          path: '/onboarding/permissions',
          builder: (_, __) => const PermissionsScreen()),
      GoRoute(
          path: '/onboarding/device-scan',
          builder: (_, __) => const DeviceScanScreen()),
      GoRoute(
          path: '/onboarding/pool',
          builder: (_, __) => const InterventionPoolScreen()),
      GoRoute(
          path: '/onboarding/calibration',
          builder: (_, __) => const CalibrationScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
              path: '/home/dashboard',
              builder: (_, __) => const DashboardScreen()),
          GoRoute(
              path: '/home/history', builder: (_, __) => const HistoryScreen()),
          GoRoute(
              path: '/home/settings',
              builder: (_, __) => const SettingsScreen()),
        ],
      ),
      GoRoute(
          path: '/settings/device-pairing',
          builder: (_, __) => const DevicePairingScreen()),
      GoRoute(path: '/settings/about', builder: (_, __) => const AboutScreen()),
    ],
  );

  return router;
});

String? _redirect(Ref ref, GoRouterState state) {
  if (state.matchedLocation == '/') return null;
  final async = ref.read(onboardingStatusProvider);
  if (async.isLoading) return '/';
  final step = async.value ?? OnboardingStep.welcome;
  final complete = step == OnboardingStep.complete;
  final onOnboarding = state.matchedLocation.startsWith('/onboarding');
  final onHome = state.matchedLocation.startsWith('/home');
  if (!complete && onHome) return _stepRoute(step);
  if (complete && onOnboarding) return '/home/dashboard';
  return null;
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
