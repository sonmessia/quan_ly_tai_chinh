import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF6200EE),
    scaffoldBackgroundColor: Colors.grey[50],
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
}