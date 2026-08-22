import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();
  static const primary = Color(0xFF00D4FF);
  static const secondary = Color(0xFF7C4DFF);
  static const background = Color(0xFF060A14);
  static const surface = Color(0xFF0B1120);
  static const onPrimary = Color(0xFF000C18);
  static const error = Color(0xFFFF4560);
  static const fontPrimary = Color(0xFFE8EAF6);
  static const fontSecondary = Color(0xFF7986A0);
  static const stressHigh = Color(0xFFFF4560);
  static const stressMid = Color(0xFFFFB300);
  static const stressLow = Color(0xFF69F0AE);
  static const glassWhite = Color(0x14FFFFFF);
  static const glassBorder = Color(0x2EFFFFFF);
  static const glassHighlight = Color(0x0AFFFFFF);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.fontPrimary,
          onSurface: AppColors.fontPrimary,
          error: AppColors.error,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.fontPrimary),
          headlineLarge: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.fontPrimary),
          headlineMedium: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.fontPrimary),
          titleLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.fontPrimary),
          titleMedium: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.fontPrimary),
          bodyLarge: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.fontPrimary),
          bodyMedium: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.fontSecondary),
          labelLarge: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.fontPrimary),
          labelMedium: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.fontSecondary),
          labelSmall: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.fontSecondary),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.fontPrimary),
          iconTheme: IconThemeData(color: AppColors.fontPrimary),
        ),
        iconTheme: const IconThemeData(color: AppColors.fontPrimary),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size.fromHeight(52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            minimumSize: const Size.fromHeight(52),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.glassWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.glassBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          labelStyle:
              const TextStyle(fontSize: 14, color: AppColors.fontSecondary),
          hintStyle:
              const TextStyle(fontSize: 14, color: AppColors.fontSecondary),
        ),
      );
}
