import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppColors {
  // Brand Colors - Royal Khmer Palette
  static const Color primary = Color(0xFFD4AF37);      // Khmer Royal Gold
  static const Color primaryDark = Color(0xFFA88314);  // Darker Gold
  static const Color primaryLight = Color(0xFFF7E7A1); // Soft Light Gold
  
  static const Color secondary = Color(0xFF0F4C3A);    // Deep Angkor Emerald Green
  static const Color secondaryLight = Color(0xFF1E6B54);
  
  static const Color accent = Color(0xFFE07A5F);       // Warm Kroeung Spice Orange
  static const Color accentRed = Color(0xFFC0392B);    // Khmer Red / Chili
  
  // Neutral Colors (Dark Mode & Light Mode)
  static const Color bgDark = Color(0xFF121418);       // Modern Deep Surface
  static const Color cardDark = Color(0xFF1C2026);     // Card background in Dark mode
  static const Color surfaceDark = Color(0xFF262C36);
  
  static const Color bgLight = Color(0xFFF6F7FA);      // Soft Light Background
  static const Color cardLight = Color(0xFFFFFFFF);    // Light Card
  static const Color surfaceLight = Color(0xFFEFF2F6);

  // Text Colors
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const Color textPrimaryLight = Color(0xFF0F172A); // Deep Crisp Charcoal
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Helper Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFE6C200)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [secondary, Color(0xFF165B47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xCC0F4C3A), Color(0xEE121418)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

extension ThemeContextX on BuildContext {
  Color get cardBg => isDarkMode ? AppColors.cardDark : AppColors.cardLight;
  Color get surfaceBg => isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get textPrimary => isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  Color get textSecondary => isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  Color get borderColor => isDarkMode ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.08);
}
