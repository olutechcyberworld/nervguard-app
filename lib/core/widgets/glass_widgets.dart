import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Glassmorphism card: blur backdrop + semi-transparent fill + border.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final Color? borderColor;
  final Color? backgroundColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.blur = 10,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassWhite,
            borderRadius: borderRadius,
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Full-screen gradient background used on every screen.
class GlassBackground extends StatelessWidget {
  final Widget child;

  const GlassBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D1A2E),
            Color(0xFF060A14),
            Color(0xFF0A0614),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}

/// Accent orbs for visual depth — placed behind content in a Stack.
class GlassOrbs extends StatelessWidget {
  const GlassOrbs({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -80,
          left: -60,
          child: _orb(200, AppColors.primary.withValues(alpha: 0.12)),
        ),
        Positioned(
          bottom: 100,
          right: -80,
          child: _orb(250, AppColors.secondary.withValues(alpha: 0.10)),
        ),
      ],
    );
  }

  Widget _orb(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}
