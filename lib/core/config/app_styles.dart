import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2E5BFF);
  static const Color secondary = Color(0xFF2BC990);
  static const Color accent = Color(0xFFFB7181);
  static const Color background = Colors.white;
  static const Color surface = Color(0xFFF5F6FA);
  static const Color text = Color(0xFF1A1B1E);
  static const Color textSecondary = Color(0xFF9A9CA5);
  static const Color border = Color(0xFFE5E5E5);
}

class AppStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
    letterSpacing: 0.5,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.text,
  );

  static final BorderRadius borderRadius = BorderRadius.circular(16);

  static final BoxShadow cardShadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );

  static final InputDecoration textFieldDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );
}