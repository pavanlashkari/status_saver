import 'package:flutter/material.dart';

class AppColors {
  // Dark theme colors
  static const background = Color(0xFF060F15);
  static const surface = Color(0xFF0F1F26);
  static const surfaceLight = Color(0xFF162A33);
  static const cardBorder = Color(0xFF1A3040);
  static const mint = Color(0xFF66E8C0);
  static const mintDark = Color(0xFF4DC9A4);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF8A9BA7);
  static const textMuted = Color(0xFF556670);
  static const danger = Color(0xFFFF6B6B);

  // Light theme colors
  static const lightBg = Color(0xFFF5F7FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceAlt = Color(0xFFF0F3F6);
  static const lightText = Color(0xFF1A1A2E);
  static const lightTextSecondary = Color(0xFF6B7280);
}

class AppTheme {
  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.mint,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.mint,
          secondary: AppColors.mint,
          surface: AppColors.surface,
          onPrimary: AppColors.background,
          onSurface: AppColors.textPrimary,
          outline: AppColors.textMuted,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.mint,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.cardBorder, width: 0.5),
          ),
        ),
        dividerColor: AppColors.cardBorder,
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceLight,
          contentTextStyle: const TextStyle(color: AppColors.textPrimary),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.mint,
        scaffoldBackgroundColor: AppColors.lightBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.mint,
          secondary: AppColors.mint,
          surface: AppColors.lightSurface,
          onPrimary: Colors.white,
          onSurface: AppColors.lightText,
          outline: AppColors.lightTextSecondary,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.lightBg,
          foregroundColor: AppColors.lightText,
          surfaceTintColor: Colors.transparent,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.mintDark,
          unselectedItemColor: AppColors.lightTextSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showUnselectedLabels: true,
          selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
        ),
        dividerColor: Colors.grey.shade200,
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
}
