import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors - Modern Blue Palette
  static const Color primary = Color(0xFF2563EB); // Vibrant blue
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Secondary Colors - Professional Teal
  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);
  static const Color secondarySurface = Color(0xFFECFDF5);

  // Accent Colors - Energetic Purple
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);
  static const Color accentSurface = Color(0xFFF3F4F6);

  // Semantic Colors - Enhanced
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  static const Color successSurface = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningSurface = Color(0xFFFFFBEB);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorSurface = Color(0xFFFEF2F2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoSurface = Color(0xFFEFF6FF);

  // Neutral Colors - Modern Gray Scale
  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);

  // Text Colors - Enhanced Hierarchy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderFocus = Color(0xFF3B82F6);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF06B6D4)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFBFC), Color(0xFFF8FAFC)],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  // Glass Effect Colors
  static const Color glass = Color(0x40FFFFFF);
  static const Color glassLight = Color(0x20FFFFFF);
  static const Color glassDark = Color(0x10000000);

  // Shadow Colors
  static const Color shadowLight = Color(0x08000000);
  static const Color shadowMedium = Color(0x12000000);
  static const Color shadowDark = Color(0x20000000);

  // Emotion Colors for Analytics
  static const Color emotionJoy = Color(0xFFFEF08A);
  static const Color emotionSadness = Color(0xFF93C5FD);
  static const Color emotionAnger = Color(0xFFFCA5A5);
  static const Color emotionFear = Color(0xFFD8B4FE);
  static const Color emotionSurprise = Color(0xFFA7F3D0);
  static const Color emotionDisgust = Color(0xFFFDE047);
  static const Color emotionNeutral = Color(0xFFE5E7EB);

  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF84CC16),
  ];

  // Legacy/Backward compatibility colors
  static const Color positive = success;
  static const Color negative = error;
  static const Color neutral = textTertiary;
  static const Color urgent = error;

  // Team colors
  static const Color salesTeam = Color(0xFF8B5CF6);
  static const Color customerServiceTeam = Color(0xFF06B6D4);
  static const Color supportTeam = Color(0xFF10B981);
  static const Color managementTeam = Color(0xFFEF4444);
  static const Color divider = Color(0xFFE5E7EB);

  // Utility Methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
