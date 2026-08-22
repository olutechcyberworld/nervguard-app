import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';
import '../../../domain/models/intervention_overlay_state.dart';
import '../../providers/foreground_intervention_engine_provider.dart';
import '../../providers/inference_consumer_provider.dart';
// import '../../providers/inference_providers.dart';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(inferenceConsumerProvider);
    final overlayAsync = ref.watch(foregroundInterventionEngineProvider);
    final overlayState = overlayAsync.value;

    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: child,
            bottomNavigationBar: const _GlassNavBar(),
          ),
          if (overlayState is OverlayActive)
            _InterventionOverlay(state: overlayState, ref: ref),
        ],
      ),
    );
  }
}

class _GlassNavBar extends ConsumerWidget {
  const _GlassNavBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final index = location.startsWith('/home/history')
        ? 1
        : location.startsWith('/home/settings')
            ? 2
            : 0;

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.glassWhite,
            border: Border(top: BorderSide(color: AppColors.glassBorder)),
          ),
          child: NavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: index,
            onDestinationSelected: (i) {
              switch (i) {
                case 0:
                  context.go('/home/dashboard');
                case 1:
                  context.go('/home/history');
                case 2:
                  context.go('/home/settings');
              }
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.monitor_heart_outlined),
                selectedIcon: Icon(Icons.monitor_heart),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: 'History',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterventionOverlay extends StatelessWidget {
  final OverlayActive state;
  final WidgetRef ref;
  const _InterventionOverlay({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => ref
            .read(foregroundInterventionEngineProvider.notifier)
            .respond(helped: false),
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GlassCard(
                padding: const EdgeInsets.all(24),
                borderRadius: BorderRadius.circular(20),
                borderColor: AppColors.primary.withValues(alpha: 0.4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.15),
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.self_improvement,
                          color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.tier == 'intensive'
                          ? 'Stress Intervention'
                          : 'Stress Relief',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.intervention,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: AppColors.primary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Elevated stress detected. Try this to help yourself.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => ref
                                .read(foregroundInterventionEngineProvider
                                    .notifier)
                                .respond(helped: false),
                            child: const Text('Skip'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => ref
                                .read(foregroundInterventionEngineProvider
                                    .notifier)
                                .respond(helped: true),
                            child: const Text('Helped'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
