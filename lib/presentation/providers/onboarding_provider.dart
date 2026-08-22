import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/preferences/app_preferences.dart';
import 'infrastructure_providers.dart';

class OnboardingStatusNotifier extends AsyncNotifier<OnboardingStep> {
  @override
  Future<OnboardingStep> build() async {
    final prefs = await ref.watch(appPreferencesProvider.future);
    return prefs.getOnboardingStep();
  }

  Future<void> advance(OnboardingStep next) async {
    final prefs = await ref.read(appPreferencesProvider.future);
    await prefs.setOnboardingStep(next);
    state = AsyncData(next);
  }
}

final onboardingStatusProvider =
    AsyncNotifierProvider<OnboardingStatusNotifier, OnboardingStep>(
  OnboardingStatusNotifier.new,
);
