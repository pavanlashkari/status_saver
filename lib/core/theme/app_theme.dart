import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF00A884);
  static const _darkBg = Color(0xFF111B21);
  static const _darkSurface = Color(0xFF1F2C34);

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: _primaryColor,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: _primaryColor,
          indicatorColor: _primaryColor,
        ),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: _primaryColor,
        useMaterial3: true,
        scaffoldBackgroundColor: _darkBg,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: _darkSurface,
        ),
        tabBarTheme: const TabBarThemeData(
          labelColor: _primaryColor,
          indicatorColor: _primaryColor,
        ),
      );
}
