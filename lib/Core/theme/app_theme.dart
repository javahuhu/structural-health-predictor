import 'package:flutter/material.dart';

abstract final class AppPalette {
  static const Color ink = Color(0xFF1A1A2E);
  static const Color primary = Color(0xFF0F3460);
  static const Color primaryDeep = Color(0xFF16213E);
  static const Color canvasLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color canvasDark = Color(0xFF101826);
  static const Color surfaceDark = Color(0xFF16213E);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFF9F40);
  static const Color success = Color(0xFF4ECDC4);
  static const Color textPrimary = Color(0xFF0F0F0F);
  static const Color textOnDark = Color(0xFFF4F7FB);
}

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: Brightness.light,
      primary: AppPalette.primary,
      secondary: AppPalette.success,
      tertiary: AppPalette.warning,
      error: AppPalette.danger,
      surface: AppPalette.canvasLight,
      onSurface: AppPalette.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppPalette.canvasLight,
      cardColor: AppPalette.surfaceLight,
      canvasColor: AppPalette.canvasLight,
      disabledColor: AppPalette.ink.withValues(alpha: 0.35),
      dividerColor: AppPalette.ink.withValues(alpha: 0.08),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppPalette.primary,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.canvasLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(
          AppPalette.ink.withValues(alpha: 0.16),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.primary,
      brightness: Brightness.dark,
      primary: AppPalette.success,
      secondary: AppPalette.warning,
      tertiary: AppPalette.primary,
      error: AppPalette.danger,
      surface: AppPalette.canvasDark,
      onSurface: AppPalette.textOnDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppPalette.canvasDark,
      cardColor: AppPalette.surfaceDark,
      canvasColor: AppPalette.canvasDark,
      disabledColor: Colors.white.withValues(alpha: 0.3),
      dividerColor: Colors.white.withValues(alpha: 0.08),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppPalette.primaryDeep,
        contentTextStyle: const TextStyle(color: AppPalette.textOnDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppPalette.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(
          Colors.white.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}
