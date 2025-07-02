import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  // Custom Text Styles
  static const String _fontFamily = 'Inter';

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceContainer,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // Enhanced App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: AppColors.shadowLight,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
          letterSpacing: -0.02,
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),

      // Enhanced Card Theme
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shadowColor: AppColors.shadowMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Modern Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.shadowMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
            letterSpacing: -0.01,
          ),
          minimumSize: const Size(0, 52),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 48),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: Colors.transparent,
          elevation: 0,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 48),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 44),
        ),
      ),

      // Enhanced Input Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        hintStyle: const TextStyle(
          color: AppColors.textLight,
          fontSize: 14,
          fontFamily: _fontFamily,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Enhanced Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Enhanced Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
      ),

      // Enhanced Navigation Rail
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        selectedIconTheme: IconThemeData(color: AppColors.primary, size: 24),
        unselectedIconTheme: IconThemeData(
          color: AppColors.textLight,
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        elevation: 0,
      ),

      // Enhanced Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.primarySurface,
        secondarySelectedColor: AppColors.primarySurface,
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontFamily: _fontFamily,
        ),
        secondaryLabelStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.border, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // Enhanced Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primarySurface;
          }
          return AppColors.surfaceVariant;
        }),
      ),

      // Enhanced Slider Theme
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: AppColors.surfaceVariant,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primarySurface,
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
      ),

      // Enhanced Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.surfaceVariant,
        circularTrackColor: AppColors.surfaceVariant,
      ),

      // Enhanced Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // Enhanced Dialog Theme
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: 24,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
        contentTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: _fontFamily,
          height: 1.5,
        ),
      ),

      // Enhanced Typography
      textTheme: const TextTheme(
        // Display styles for hero content
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.1,
          letterSpacing: -0.02,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.2,
          letterSpacing: -0.02,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.2,
          letterSpacing: -0.01,
        ),

        // Headlines for sections
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.3,
          letterSpacing: -0.01,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.3,
          letterSpacing: -0.01,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.3,
        ),

        // Titles for cards and components
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.4,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.4,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          fontFamily: _fontFamily,
          height: 1.4,
        ),

        // Body text for content
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
          fontFamily: _fontFamily,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
          fontFamily: _fontFamily,
          height: 1.4,
        ),

        // Labels for UI elements
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: _fontFamily,
          height: 1.4,
          letterSpacing: 0.01,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          fontFamily: _fontFamily,
          height: 1.4,
          letterSpacing: 0.01,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
          fontFamily: _fontFamily,
          height: 1.4,
          letterSpacing: 0.02,
        ),
      ),

      // Enhanced Icon Theme
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 24),
      primaryIconTheme: const IconThemeData(color: AppColors.primary, size: 24),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Extensions
      extensions: const [CustomColors(), CustomShadows(), CustomSpacing()],
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,

      // Dark mode specific theme adjustments
      textTheme: lightTheme.textTheme.apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),

      extensions: const [CustomColors(), CustomShadows(), CustomSpacing()],
    );
  }

  // Enterprise Dashboard Decorations
  static BoxDecoration get dashboardGradient {
    return const BoxDecoration(gradient: AppColors.primaryGradient);
  }

  static BoxDecoration enterpriseCardDecoration({
    Color? color,
    double radius = 12,
    bool withShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
      border: Border.all(color: AppColors.border, width: 1),
    );
  }

  static BoxDecoration accentButtonDecoration({double radius = 8}) {
    return BoxDecoration(
      gradient: AppColors.accentGradient,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: AppColors.accent.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration urgentAlertDecoration({double radius = 8}) {
    return BoxDecoration(
      color: AppColors.errorSurface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.error, width: 1),
      boxShadow: [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration successAlertDecoration({double radius = 8}) {
    return BoxDecoration(
      color: AppColors.successSurface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.success, width: 1),
      boxShadow: [
        BoxShadow(
          color: AppColors.success.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // Enterprise Status Indicators
  static BoxDecoration statusIndicator(Color color, {double radius = 20}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
}

// Custom Theme Extensions
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors();

  @override
  CustomColors copyWith() => const CustomColors();

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    return const CustomColors();
  }

  // Glass effect colors
  Color get glass => AppColors.glass;
  Color get glassLight => AppColors.glassLight;
  Color get glassDark => AppColors.glassDark;

  // Emotion colors
  Color get emotionJoy => AppColors.emotionJoy;
  Color get emotionSadness => AppColors.emotionSadness;
  Color get emotionAnger => AppColors.emotionAnger;
  Color get emotionFear => AppColors.emotionFear;
  Color get emotionSurprise => AppColors.emotionSurprise;
  Color get emotionDisgust => AppColors.emotionDisgust;
  Color get emotionNeutral => AppColors.emotionNeutral;

  // Chart colors
  List<Color> get chartColors => AppColors.chartColors;
}

class CustomShadows extends ThemeExtension<CustomShadows> {
  const CustomShadows();

  @override
  CustomShadows copyWith() => const CustomShadows();

  @override
  CustomShadows lerp(ThemeExtension<CustomShadows>? other, double t) {
    return const CustomShadows();
  }

  // Shadow definitions
  List<BoxShadow> get light => [
    BoxShadow(
      color: AppColors.shadowLight,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  List<BoxShadow> get medium => [
    BoxShadow(
      color: AppColors.shadowMedium,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  List<BoxShadow> get dark => [
    BoxShadow(
      color: AppColors.shadowDark,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  List<BoxShadow> get glass => [
    BoxShadow(
      color: AppColors.glassLight,
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];
}

class CustomSpacing extends ThemeExtension<CustomSpacing> {
  const CustomSpacing();

  @override
  CustomSpacing copyWith() => const CustomSpacing();

  @override
  CustomSpacing lerp(ThemeExtension<CustomSpacing>? other, double t) {
    return const CustomSpacing();
  }

  // 8pt grid system
  double get xs => 4.0;
  double get sm => 8.0;
  double get md => 16.0;
  double get lg => 24.0;
  double get xl => 32.0;
  double get xxl => 48.0;
}
