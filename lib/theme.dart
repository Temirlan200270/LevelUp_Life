// lib/theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0A0E1A),
    primaryColor: const Color(0xFF00BFFF),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00BFFF),
      secondary: Color(0xFF8A2BE2),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF101422),
      selectedItemColor: Color(0xFF00BFFF),
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF00BFFF),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1A2033),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}