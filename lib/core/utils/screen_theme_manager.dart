import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Utility class for managing screen themes and customizations
class ScreenThemeManager {
  static const Duration _defaultAnimationDuration = Duration(milliseconds: 300);
  static const Curve _defaultAnimationCurve = Curves.easeInOut;

  // Animation configurations
  static const Duration splashAnimationDuration = Duration(milliseconds: 2000);
  static const Duration onboardingAnimationDuration = Duration(milliseconds: 400);
  static const Duration loadingAnimationDuration = Duration(milliseconds: 1500);
  static const Duration transitionAnimationDuration = Duration(milliseconds: 300);

  // Screen-specific themes
  static const ScreenTheme splashTheme = ScreenTheme(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    textColor: AppColors.textPrimary,
    animationDuration: splashAnimationDuration,
    borderRadius: 30.0,
    elevation: 0.0,
  );

  static const ScreenTheme onboardingTheme = ScreenTheme(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    textColor: AppColors.textPrimary,
    animationDuration: onboardingAnimationDuration,
    borderRadius: 16.0,
    elevation: 2.0,
  );

  static const ScreenTheme loadingTheme = ScreenTheme(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    textColor: AppColors.textPrimary,
    animationDuration: loadingAnimationDuration,
    borderRadius: 12.0,
    elevation: 4.0,
  );

  static const ScreenTheme errorTheme = ScreenTheme(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.error,
    accentColor: AppColors.errorLight,
    textColor: AppColors.textPrimary,
    animationDuration: _defaultAnimationDuration,
    borderRadius: 16.0,
    elevation: 0.0,
  );

  static const ScreenTheme emptyStateTheme = ScreenTheme(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.textTertiary,
    accentColor: AppColors.surfaceContainer,
    textColor: AppColors.textSecondary,
    animationDuration: _defaultAnimationDuration,
    borderRadius: 16.0,
    elevation: 0.0,
  );

  static const ScreenTheme settingsTheme = ScreenTheme(
    backgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    accentColor: AppColors.accent,
    textColor: AppColors.textPrimary,
    animationDuration: _defaultAnimationDuration,
    borderRadius: 12.0,
    elevation: 1.0,
  );

  // Helper methods for common decorations
  static BoxDecoration getCardDecoration({
    Color? backgroundColor,
    double? borderRadius,
    double? elevation,
    Color? shadowColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.05),
          blurRadius: elevation ?? 4.0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration getButtonDecoration({
    required Color backgroundColor,
    double borderRadius = 12.0,
    double elevation = 2.0,
    Color? shadowColor,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? backgroundColor).withValues(alpha: 0.3),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation),
        ),
      ],
    );
  }

  static LinearGradient getGradientDecoration({
    required Color startColor,
    required Color endColor,
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [startColor, endColor],
    );
  }

  // Text styles for different screen types
  static TextStyle getHeadingStyle({
    double fontSize = 24.0,
    FontWeight fontWeight = FontWeight.bold,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textPrimary,
      letterSpacing: -0.5,
    );
  }

  static TextStyle getSubheadingStyle({
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.w500,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textSecondary,
      height: 1.5,
    );
  }

  static TextStyle getBodyStyle({
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textSecondary,
      height: 1.6,
    );
  }

  static TextStyle getCaptionStyle({
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.textTertiary,
      height: 1.4,
    );
  }

  // Button styles
  static ButtonStyle getPrimaryButtonStyle({
    Color? backgroundColor,
    Color? foregroundColor,
    double borderRadius = 12.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      elevation: 2.0,
    );
  }

  static ButtonStyle getSecondaryButtonStyle({
    Color? backgroundColor,
    Color? foregroundColor,
    double borderRadius = 12.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  }) {
    return OutlinedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? AppColors.primary,
      side: BorderSide(color: foregroundColor ?? AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }

  static ButtonStyle getTextButtonStyle({
    Color? foregroundColor,
    double borderRadius = 8.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) {
    return TextButton.styleFrom(
      foregroundColor: foregroundColor ?? AppColors.textSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
    );
  }

  // Input decoration
  static InputDecoration getInputDecoration({
    required String hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    Color? fillColor,
    Color? borderColor,
    double borderRadius = 12.0,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.textSecondary)
          : null,
      suffixIcon: suffixIcon != null
          ? IconButton(
              icon: Icon(suffixIcon, color: AppColors.textSecondary),
              onPressed: onSuffixIconTap,
            )
          : null,
      filled: true,
      fillColor: fillColor ?? AppColors.surfaceContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor ?? AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: borderColor ?? AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Animation configurations
  static AnimationController createAnimationController({
    required TickerProvider vsync,
    Duration? duration,
  }) {
    return AnimationController(
      duration: duration ?? _defaultAnimationDuration,
      vsync: vsync,
    );
  }

  static Animation<double> createFadeAnimation({
    required AnimationController controller,
    Curve curve = _defaultAnimationCurve,
    double begin = 0.0,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  static Animation<Offset> createSlideAnimation({
    required AnimationController controller,
    Curve curve = _defaultAnimationCurve,
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }

  static Animation<double> createScaleAnimation({
    required AnimationController controller,
    Curve curve = _defaultAnimationCurve,
    double begin = 0.8,
    double end = 1.0,
  }) {
    return Tween<double>(
      begin: begin,
      end: end,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }
}

/// Model class for screen theme configuration
class ScreenTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final Color accentColor;
  final Color textColor;
  final Duration animationDuration;
  final double borderRadius;
  final double elevation;

  const ScreenTheme({
    required this.backgroundColor,
    required this.primaryColor,
    required this.accentColor,
    required this.textColor,
    required this.animationDuration,
    required this.borderRadius,
    required this.elevation,
  });
}

/// Extension methods for enhanced screen functionality
extension ScreenExtensions on Widget {
  Widget withPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  Widget withMargin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }

  Widget withBackground(Color color) {
    return Container(color: color, child: this);
  }

  Widget withBorder({
    Color color = AppColors.border,
    double width = 1.0,
    double radius = 8.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: this,
    );
  }

  Widget withShadow({
    Color color = Colors.black,
    double opacity = 0.1,
    double blurRadius = 4.0,
    Offset offset = const Offset(0, 2),
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: opacity),
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
      child: this,
    );
  }

  Widget withAnimation({
    required AnimationController controller,
    Curve curve = Curves.easeInOut,
    AnimationType type = AnimationType.fade,
  }) {
    late Animation<double> animation;
    late Animation<Offset> slideAnimation;

    switch (type) {
      case AnimationType.fade:
        animation = ScreenThemeManager.createFadeAnimation(
          controller: controller,
          curve: curve,
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => FadeTransition(
            opacity: animation,
            child: this,
          ),
        );

      case AnimationType.slide:
        slideAnimation = ScreenThemeManager.createSlideAnimation(
          controller: controller,
          curve: curve,
        );
        return AnimatedBuilder(
          animation: slideAnimation,
          builder: (context, child) => SlideTransition(
            position: slideAnimation,
            child: this,
          ),
        );

      case AnimationType.scale:
        animation = ScreenThemeManager.createScaleAnimation(
          controller: controller,
          curve: curve,
        );
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) => ScaleTransition(
            scale: animation,
            child: this,
          ),
        );
    }
  }
}

enum AnimationType {
  fade,
  slide,
  scale,
}
