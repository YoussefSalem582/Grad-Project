import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF3B82F6); // Blue
  static const Color secondary = Color(0xFF10B981); // Green
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1E40AF);

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Background colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color divider = Color(0xFFE5E7EB);

  // Gradient
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Legacy colors for backward compatibility
  static const Color accent = primary;
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const List<Color> accentGradient = primaryGradient;

  // Enterprise Colors
  static const Color accentColor = Color(0xFF3B82F6); // Blue-500

  // Customer Service Specific Colors
  static const Color positive = Color(
    0xFF10B981,
  ); // Green for positive sentiment
  static const Color negative = Color(0xFFEF4444); // Red for negative sentiment
  static const Color neutral = Color(0xFF6B7280); // Gray for neutral sentiment
  static const Color urgent = Color(0xFFEF4444); // Bright red for urgent issues

  // Team Colors
  static const Color customerServiceTeam = Color(0xFF3B82F6); // Blue
  static const Color salesTeam = Color(0xFF10B981); // Green
  static const Color supportTeam = Color(0xFF8B5CF6); // Purple
  static const Color marketingTeam = Color(0xFFEF4444); // Red
  static const Color managementTeam = Color(0xFFF59E0B); // Amber

  // Gradients as List<Color>
  static const List<Color> primaryGradient = [
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
  ];
  static const List<Color> successGradient = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];
  static const List<Color> warningGradient = [
    Color(0xFFF59E0B),
    Color(0xFFFBBF24),
  ];
  static const List<Color> errorGradient = [
    Color(0xFFEF4444),
    Color(0xFFF87171),
  ];

  // Background Colors - Clean enterprise look
  static const Color backgroundColor = Color(0xFFF8FAFC); // Slate-50
  static const Color surfaceColor = Colors.white;
  static const Color cardBackgroundColor = Colors.white;
  static const Color dashboardBackgroundColor = Color(0xFFF1F5F9); // Slate-100

  // Text Colors - Professional hierarchy
  static const Color textPrimaryColor = Color(0xFF0F172A); // Slate-900
  static const Color textSecondaryColor = Color(0xFF475569); // Slate-600
  static const Color textLightColor = Color(0xFF64748B); // Slate-500

  // Enterprise Status Colors
  static const Color successColor = Color(0xFF059669); // Emerald-600
  static const Color errorColor = Color(0xFFDC2626); // Red-600
  static const Color warningColor = Color(0xFFD97706); // Amber-600
  static const Color infoColor = Color(0xFF2563EB); // Blue-600

  // Customer Service Specific Colors
  static const Color positiveColor = Color(
    0xFF059669,
  ); // Green for positive sentiment
  static const Color negativeColor = Color(
    0xFFDC2626,
  ); // Red for negative sentiment
  static const Color neutralColor = Color(
    0xFF6B7280,
  ); // Gray for neutral sentiment
  static const Color urgentColor = Color(
    0xFFEF4444,
  ); // Bright red for urgent issues

  // Enhanced Emotion Colors for Professional Use
  static const Color joyColorColor = Color(0xFFF59E0B); // Amber-500
  static const Color sadnessColorColor = Color(0xFF3B82F6); // Blue-500
  static const Color angerColorColor = Color(0xFFEF4444); // Red-500
  static const Color fearColorColor = Color(0xFF8B5CF6); // Violet-500
  static const Color surpriseColorColor = Color(0xFF06B6D4); // Cyan-500
  static const Color disgustColorColor = Color(0xFF84CC16); // Lime-500
  static const Color neutralColorColor = Color(0xFF6B7280); // Gray-500

  // Enterprise Dashboard Gradients
  static const List<Color> primaryGradientColor = [
    Color(0xFF1E293B),
    Color(0xFF334155),
    Color(0xFF475569),
  ];

  static const List<Color> accentGradientColor = [
    Color(0xFF3B82F6),
    Color(0xFF1D4ED8),
  ];

  static const List<Color> successGradientColor = [
    Color(0xFF059669),
    Color(0xFF047857),
  ];

  static const List<Color> warningGradientColor = [
    Color(0xFFD97706),
    Color(0xFFB45309),
  ];

  static const List<Color> errorGradientColor = [
    Color(0xFFDC2626),
    Color(0xFFB91C1C),
  ];

  // Department/Team Colors for Multi-team Analytics
  static const Color customerServiceTeamColor = Color(0xFF3B82F6); // Blue
  static const Color salesTeamColor = Color(0xFF059669); // Green
  static const Color supportTeamColor = Color(0xFF8B5CF6); // Purple
  static const Color marketingTeamColor = Color(0xFFEF4444); // Red
  static const Color managementTeamColor = Color(0xFFF59E0B); // Amber
}
