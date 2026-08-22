import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassBackground(
      child: Stack(
        children: [
          const GlassOrbs(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: const Text('About')),
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset('assets/app_icon/app_icon.png',
                            width: 72,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.monitor_heart,
                                color: AppColors.primary,
                                size: 72)),
                        const SizedBox(height: 12),
                        Text('NervGuard',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text('Version 1.0.0',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text(
                            'Autonomic Stress Detection & Intervention Platform',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Developer',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Image.asset('assets/brand/olutech_logo.png',
                                width: 40,
                                height: 40,
                                errorBuilder: (_, __, ___) => Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.2),
                                      ),
                                      child: const Icon(Icons.business,
                                          color: AppColors.secondary, size: 20),
                                    )),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Olutech',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                Text(
                                    'Innovating at the edge of health and IoT.',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Technology Stack',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 16),
                        ...[
                          (
                            'Hardware',
                            'ESP32-S3 · BVP/PPG · EDA · Accelerometer · Temperature'
                          ),
                          (
                            'Machine Learning',
                            'TFLite Micro · WESAD dataset · int8 quantisation'
                          ),
                          ('Connectivity', 'BLE 5.0 · Custom GATT service'),
                          (
                            'App',
                            'Flutter · Riverpod · Drift/SQLite · Supabase'
                          ),
                          (
                            'Classification',
                            'Binary stress classifier · 85.4% LOSO accuracy'
                          ),
                          (
                            'Intervention',
                            'Time-based escalation · EMA preference weighting'
                          ),
                        ].map((entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(entry.$1,
                                        style: const TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Expanded(
                                      child: Text(entry.$2,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Research Basis',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'Trained on the WESAD dataset (Wearable Stress and Affect Detection) '
                          'from the University of Augsburg. Leave-one-subject-out cross-validation '
                          'over 15 subjects. Binary stress classifier with fixed probability '
                          'thresholds (0.40 / 0.70) and time-based intervention escalation.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text('© 2025 Olutech. All rights reserved.',
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
