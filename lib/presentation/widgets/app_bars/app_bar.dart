import 'package:flutter/material.dart';
import '../../../core/core.dart';
import 'components/animated_app_icon.dart';
import 'components/app_bar_back_button.dart';
import 'components/app_bar_title_section.dart';
import 'components/app_bar_notification_button.dart';
import 'components/app_bar_status_indicator.dart';
import 'components/app_bar_stats_row.dart';
import 'components/app_bar_background_effects.dart';

/// A modern, reusable app bar component for employee screens with gradient background,
/// animated elements, and optional statistics display.
class ModernEmployeeAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// The main title text displayed in the app bar
  final String title;

  /// The subtitle text displayed below the title
  final String subtitle;

  /// The main icon displayed on the left side of the title
  final IconData mainIcon;

  /// List of statistics to display below the main content (optional)
  /// When empty, the app bar height is reduced and no stats are shown
  final List<StatItem> stats;

  /// Callback function for notification button press (optional)
  /// When null, the notification button is not displayed
  final VoidCallback? onNotificationPressed;

  /// Whether to show an unread notification indicator (red dot)
  final bool hasUnreadNotifications;

  /// Number of unread notifications to display in badge (optional)
  /// When null, shows only a simple red dot indicator
  final int? notificationCount;

  /// Custom accessibility label for the main icon (optional)
  final String? iconSemanticLabel;

  /// Whether to show the back navigation button
  final bool showBackButton;

  /// Current availability status of the employee (affects status indicator color)
  final bool isAvailable;

  /// Starting color for the gradient background (optional)
  /// Defaults to Color(0xFF667eea) if not provided
  final Color? gradientStart;

  /// Ending color for the gradient background (optional)
  /// Defaults to Color(0xFF764ba2) if not provided
  final Color? gradientEnd;

  const ModernEmployeeAppBar({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mainIcon,
    required this.stats,
    this.onNotificationPressed,
    this.showBackButton = true,
    this.isAvailable = true,
    this.hasUnreadNotifications = false,
    this.notificationCount,
    this.iconSemanticLabel,
    this.gradientStart,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      // Enhanced main container with advanced animated gradient background
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradientStart ?? const Color(0xFF667eea),
            (gradientStart ?? const Color(0xFF667eea)).withValues(alpha: 0.8),
            gradientEnd ?? const Color(0xFF764ba2),
            (gradientEnd ?? const Color(0xFF764ba2)).withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
        // Enhanced shadow effects with multiple layers and color blending
        boxShadow: [
          BoxShadow(
            color: (gradientStart ?? const Color(0xFF667eea)).withValues(
              alpha: 0.4,
            ),
            blurRadius: 25,
            offset: const Offset(0, 12),
            spreadRadius: 3,
          ),
          BoxShadow(
            color: (gradientEnd ?? const Color(0xFF764ba2)).withValues(
              alpha: 0.2,
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
          // Additional ambient shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 20),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Advanced animated background effects
          const AppBarBackgroundEffects(),

          // Main content with enhanced accessibility
          SafeArea(
            bottom: false, // Don't apply safe area to bottom
            child: Semantics(
              container: true,
              header: true,
              label: 'Employee app bar with $title screen navigation',
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  customSpacing.lg,
                  customSpacing.md + 4,
                  customSpacing.lg,
                  customSpacing.lg + 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main app bar row with title, icon, and actions
                    _buildAppBarRow(context, customSpacing),

                    // Conditional statistics row - only shown when stats are provided
                    if (stats.isNotEmpty) ...[
                      SizedBox(height: customSpacing.lg + 8),
                      AppBarStatsRow(
                        stats: stats,
                        customSpacing: customSpacing,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main horizontal row containing back button, icon, title, and action buttons
  Widget _buildAppBarRow(BuildContext context, CustomSpacing customSpacing) {
    return Row(
      children: [
        // Conditional back button - only shown when showBackButton is true
        if (showBackButton) ...[
          AppBarBackButton(customSpacing: customSpacing),
          SizedBox(width: customSpacing.sm),
        ],

        // Animated app icon with scaling effect
        AnimatedAppIcon(
          semanticLabel: iconSemanticLabel,
          customSpacing: customSpacing,
        ),
        SizedBox(width: customSpacing.md),

        // Expandable title section
        AppBarTitleSection(title: title, subtitle: subtitle),

        // Action buttons (notification + status indicator)
        _buildActionButtons(context, customSpacing),
      ],
    );
  }

  /// Builds the action buttons section on the right side of the app bar
  Widget _buildActionButtons(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Row(
      children: [
        // Conditional notification button
        if (onNotificationPressed != null) ...[
          AppBarNotificationButton(
            onPressed: onNotificationPressed!,
            hasUnreadNotifications: hasUnreadNotifications,
            notificationCount: notificationCount,
            customSpacing: customSpacing,
          ),
          SizedBox(width: customSpacing.xs),
        ],

        // Always present status indicator
        AppBarStatusIndicator(
          isAvailable: isAvailable,
          customSpacing: customSpacing,
        ),
      ],
    );
  }

  /// Returns the preferred size for this app bar
  @override
  Size get preferredSize => Size.fromHeight(stats.isEmpty ? 120 : 220);
}

/// Data model for individual statistics displayed in the app bar
class StatItem {
  /// The descriptive label for this statistic (e.g., "Active Tickets")
  final String label;

  /// The main value to display prominently (e.g., "12", "94%")
  final String value;

  /// Additional context or change indicator (e.g., "+3 today", "+5%")
  final String subtitle;

  /// Icon to represent this statistic visually
  final IconData icon;

  /// Accent color used for the icon background and subtitle text
  final Color accentColor;

  /// Creates a new StatItem instance
  const StatItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}
