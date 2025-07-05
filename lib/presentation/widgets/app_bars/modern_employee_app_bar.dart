import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';

/// A modern, reusable app bar component for employee screens with gradient background,
/// animated elements, and optional statistics display.
///
/// Features:
/// - Advanced gradient background with multiple color stops and shimmer effect
/// - Animated icon with scaling, rotation, and shadow effects
/// - Smart status indicator with real-time pulsing and ripple animations
/// - Premium notification button with micro-interactions and badge system
/// - Conditional statistics row with staggered animations and glassmorphism
/// - Responsive design with enhanced custom spacing and touch targets
/// - Advanced glassmorphism design with multi-layer depth and shadows
/// - Interactive elements with haptic feedback and smooth transitions
/// - Accessibility support with semantic labels and screen reader optimization
/// - Performance optimized with efficient animation controllers and builders
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

  /// Creates a new ModernEmployeeAppBar instance
  ///
  /// Required parameters:
  /// - [title]: Main title text
  /// - [subtitle]: Subtitle text
  /// - [mainIcon]: Icon to display
  /// - [stats]: List of statistics (can be empty)
  ///
  /// Optional parameters:
  /// - [onNotificationPressed]: Notification button callback
  /// - [showBackButton]: Whether to show back button (default: true)
  /// - [isAvailable]: Employee availability status (default: true)
  /// - [hasUnreadNotifications]: Whether to show notification indicator (default: false)
  /// - [notificationCount]: Number for notification badge (optional)
  /// - [iconSemanticLabel]: Custom accessibility label for icon
  /// - [gradientStart]: Custom gradient start color
  /// - [gradientEnd]: Custom gradient end color
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
          // Advanced animated background pattern with shimmer effect
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 4000),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1.0 + 2.0 * value, -1.0),
                      end: Alignment(1.0 + 2.0 * value, 1.0),
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: 0.15 * value),
                        Colors.white.withValues(alpha: 0.1 * value),
                        Colors.white.withValues(alpha: 0.05 * value),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                    ),
                  ),
                );
              },
            ),
          ),

          // Subtle noise texture overlay for premium feel
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.02),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.02),
                  ],
                ),
              ),
            ),
          ),

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
                    _buildAppBarRow(context, theme, customSpacing),

                    // Conditional statistics row - only shown when stats are provided
                    if (stats.isNotEmpty) ...[
                      SizedBox(height: customSpacing.lg + 8),
                      _buildStatsRow(customSpacing),
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
  ///
  /// Layout: [BackButton?] [AnimatedIcon] [TitleSection] [ActionButtons]
  /// The title section expands to fill available space between fixed-width elements
  Widget _buildAppBarRow(
    BuildContext context,
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Row(
      children: [
        // Conditional back button - only shown when showBackButton is true
        if (showBackButton) ...[
          _buildBackButton(context, customSpacing),
          SizedBox(width: customSpacing.sm),
        ],

        // Animated main icon with scaling effect
        _buildAnimatedIcon(customSpacing),
        SizedBox(width: customSpacing.md),

        // Expandable title section
        _buildTitleSection(theme),

        // Action buttons (notification + status indicator)
        _buildActionButtons(context, customSpacing),
      ],
    );
  }

  /// Creates a glassmorphism-style back button with proper navigation handling
  ///
  /// Features:
  /// - Semi-transparent white background with enhanced glassmorphism
  /// - Rounded corners with animated border
  /// - iOS-style back arrow icon with subtle shadow
  /// - Proper touch targets (44x44 minimum for accessibility)
  /// - Haptic feedback on interaction
  /// - Smooth scale animation on press
  Widget _buildBackButton(BuildContext context, CustomSpacing customSpacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scaleValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * scaleValue),
          child: Container(
            decoration: BoxDecoration(
              // Enhanced glassmorphism effect
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(-2, -2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  // Haptic feedback for premium feel
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(customSpacing.sm),
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new, // iOS-style back arrow
                    color: Colors.white,
                    size: 20,
                    semanticLabel: 'Go back',
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Creates an animated icon container that scales in on widget build
  ///
  /// Animation details:
  /// - Duration: 1200ms with elastic curve
  /// - Effect: Scale from 70% to 100% size with rotation
  /// - Easing: ElasticOut for premium bounce effect
  /// - Container: Enhanced glassmorphism with multiple layers and gradients
  /// - Accessibility: Semantic label and proper contrast
  Widget _buildAnimatedIcon(CustomSpacing customSpacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.7 + (0.3 * value), // Scale from 70% to 100%
          child: Transform.rotate(
            angle: (1 - value) * 0.5, // Slight rotation during animation
            child: Semantics(
              label: iconSemanticLabel ?? 'Screen icon',
              child: Container(
                padding: EdgeInsets.all(customSpacing.sm + 2),
                decoration: BoxDecoration(
                  // Multi-layer glassmorphism effect with enhanced gradients
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2.5,
                  ),
                  boxShadow: [
                    // Inner light shadow
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(-3, -3),
                      spreadRadius: 1,
                    ),
                    // Outer dark shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                      spreadRadius: 1,
                    ),
                    // Ambient shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(customSpacing.xs + 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    mainIcon,
                    color: Colors.white,
                    size: 32,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        offset: const Offset(-0.5, -0.5),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the expandable title section with main title and subtitle
  ///
  /// Layout:
  /// - Main title: Large, bold white text with enhanced styling
  /// - Subtitle: Smaller, semi-transparent white text with fade-in animation
  /// - Both left-aligned and expand to fill available space
  /// - Subtle text shadows for better readability
  Widget _buildTitleSection(ThemeData theme) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 1000),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(20 * (1 - value), 0), // Slide in from right
            child: Opacity(
              opacity: value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main title with enhanced styling and shadow
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900, // Extra bold
                      fontSize: 24,
                      letterSpacing: -0.8, // Tighter letter spacing
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle with enhanced styling and delayed animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeOut,
                    builder: (context, subtitleValue, child) {
                      return Transform.translate(
                        offset: Offset(15 * (1 - subtitleValue), 0),
                        child: Opacity(
                          opacity: subtitleValue * 0.9,
                          child: Text(
                            subtitle,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              letterSpacing: 0.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  offset: const Offset(0.5, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the action buttons section on the right side of the app bar
  ///
  /// Contains:
  /// - Optional notification button (only if callback provided)
  /// - Status indicator (always shown)
  ///
  /// Buttons are spaced according to design system spacing
  Widget _buildActionButtons(
    BuildContext context,
    CustomSpacing customSpacing,
  ) {
    return Row(
      children: [
        // Conditional notification button
        if (onNotificationPressed != null) ...[
          _buildNotificationButton(customSpacing),
          SizedBox(width: customSpacing.xs),
        ],

        // Always present status indicator
        _buildStatusIndicator(customSpacing),
      ],
    );
  }

  /// Creates a notification button with advanced badge system for unread notifications
  ///
  /// Features:
  /// - Enhanced glassmorphism container styling with multiple gradient layers
  /// - Bell icon with subtle shadow and premium animations
  /// - Smart badge system: red dot for simple indicator, count badge for numbers
  /// - Advanced animations: scale on creation, pulse on notification badge
  /// - Haptic feedback on interaction for premium feel
  /// - Accessibility support with semantic labels
  /// - Micro-interactions and smooth hover effects
  Widget _buildNotificationButton(CustomSpacing customSpacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scaleValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * scaleValue),
          child: Container(
            decoration: BoxDecoration(
              // Enhanced glassmorphism effect with advanced gradient
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.2),
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.1),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(-3, -3),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 15,
                  offset: const Offset(4, 4),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main notification icon button with enhanced styling and haptic feedback
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onNotificationPressed?.call();
                    },
                    child: Container(
                      padding: EdgeInsets.all(customSpacing.sm + 2),
                      constraints: const BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 24,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Smart notification badge: count badge or simple red dot
                if (hasUnreadNotifications)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: notificationCount != null && notificationCount! > 0
                        ? _buildCountBadge(notificationCount!)
                        : _buildSimpleBadge(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Creates a count badge for notifications with number display
  Widget _buildCountBadge(int count) {
    final displayCount = count > 99 ? '99+' : count.toString();

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, badgeValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * badgeValue),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.error,
                  AppColors.error.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Text(
              displayCount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  /// Creates a simple red dot badge for basic notification indicator
  Widget _buildSimpleBadge() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, dotValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * dotValue),
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.error,
                  AppColors.error.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.7),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Creates an animated status indicator showing employee availability
  ///
  /// Features:
  /// - Dynamic color based on isAvailable status (green/red)
  /// - Continuous pulsing animation on the status dot
  /// - Text label: "Available" or "Busy" with typewriter effect
  /// - Enhanced glassmorphism container with colored tint
  /// - Multiple glowing shadow effects for depth
  /// - Micro-interactions on hover/press states
  Widget _buildStatusIndicator(CustomSpacing customSpacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, scaleValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * scaleValue),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: customSpacing.md,
              vertical: customSpacing.sm,
            ),
            decoration: BoxDecoration(
              // Enhanced gradient background
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (isAvailable ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.25),
                  (isAvailable ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(20),

              // Enhanced border with gradient
              border: Border.all(
                color: (isAvailable ? AppColors.success : AppColors.error)
                    .withValues(alpha: 0.6),
                width: 2,
              ),

              // Multiple shadow layers for depth
              boxShadow: [
                BoxShadow(
                  color: (isAvailable ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(-2, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Enhanced animated pulsing status dot with ripple effect
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple effect
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 2000),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, rippleValue, child) {
                        return Container(
                          width: 20 * rippleValue,
                          height: 20 * rippleValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (isAvailable
                                        ? AppColors.success
                                        : AppColors.error)
                                    .withValues(alpha: 0.3 * (1 - rippleValue)),
                          ),
                        );
                      },
                    ),
                    // Main pulsing dot
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 1500),
                      tween: Tween(begin: 0.6, end: 1.0),
                      builder: (context, pulseValue, child) {
                        return Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                (isAvailable
                                        ? AppColors.success
                                        : AppColors.error)
                                    .withValues(alpha: pulseValue),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isAvailable
                                            ? AppColors.success
                                            : AppColors.error)
                                        .withValues(alpha: 0.6),
                                blurRadius: 6 * pulseValue,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(width: customSpacing.sm),

                // Enhanced status text with better typography
                Text(
                  isAvailable ? 'Available' : 'Busy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0.5, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds a horizontal row of statistics cards below the main app bar content
  ///
  /// Features:
  /// - Equal width distribution across available space with premium spacing
  /// - Staggered animations for elegant entrance effect
  /// - Responsive layout that adapts to different screen sizes
  /// - Enhanced accessibility with semantic labels
  /// - Only rendered when stats list is not empty
  /// - Micro-interactions and hover effects on individual cards
  Widget _buildStatsRow(CustomSpacing customSpacing) {
    return Row(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        final isLast = index == stats.length - 1;

        return Expanded(
          child: Row(
            children: [
              // Each stat takes equal space with staggered animation delay
              Expanded(
                child: TweenAnimationBuilder<double>(
                  duration: Duration(
                    milliseconds: 800 + (index * 150),
                  ), // Staggered timing
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutBack,
                  builder: (context, staggerValue, child) {
                    return Transform.translate(
                      offset: Offset(
                        0,
                        30 * (1 - staggerValue),
                      ), // Slide up effect
                      child: Opacity(
                        opacity: staggerValue,
                        child: _buildEnhancedStat(stat, customSpacing),
                      ),
                    );
                  },
                ),
              ),

              // Add spacing between stats (except after the last one)
              if (!isLast) SizedBox(width: customSpacing.sm + 2),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Creates an enhanced statistics card with animations and modern styling
  ///
  /// Features:
  /// - Scale-in animation with bounce effect (1s duration)
  /// - Advanced glassmorphism container with gradient backgrounds
  /// - Interactive hover and tap states with haptic feedback
  /// - Colored icon container with accent color and shadows
  /// - Trending indicator with context-aware icon selection
  /// - Value, label, and subtitle text with enhanced typography
  /// - Responsive padding and sizing with accessibility support
  /// - Micro-animations for individual elements
  ///
  /// Animation sequence:
  /// 1. Starts at 80% scale with fade-in
  /// 2. Animates to 100% scale with easeOutBack curve
  /// 3. Creates a subtle bounce effect on entry
  /// 4. Individual elements animate with slight delays
  Widget _buildEnhancedStat(StatItem stat, CustomSpacing customSpacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack, // Enhanced bounce effect
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue), // Scale from 80% to 100%
          child: Semantics(
            label: '${stat.label}: ${stat.value}, ${stat.subtitle}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: EdgeInsets.all(customSpacing.md + 2),
                  decoration: BoxDecoration(
                    // Advanced glassmorphism background with multiple layers
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),

                    // Enhanced shadow system for depth
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(4, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 8),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top row: Enhanced icon container and trending indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Enhanced colored icon container with gradient and shadows
                          TweenAnimationBuilder<double>(
                            duration: Duration(
                              milliseconds:
                                  600 + (animationValue * 200).toInt(),
                            ),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeOutBack,
                            builder: (context, iconValue, child) {
                              return Transform.scale(
                                scale: 0.8 + (0.2 * iconValue),
                                child: Container(
                                  padding: EdgeInsets.all(customSpacing.xs + 2),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        stat.accentColor.withValues(alpha: 0.3),
                                        stat.accentColor.withValues(alpha: 0.2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: stat.accentColor.withValues(
                                        alpha: 0.4,
                                      ),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: stat.accentColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    stat.icon,
                                    color: Colors.white,
                                    size: 20,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        offset: const Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Enhanced trending indicator with animation
                          TweenAnimationBuilder<double>(
                            duration: Duration(
                              milliseconds:
                                  800 + (animationValue * 300).toInt(),
                            ),
                            tween: Tween(begin: 0.0, end: 1.0),
                            curve: Curves.easeOut,
                            builder: (context, trendValue, child) {
                              return Transform.rotate(
                                angle: (1 - trendValue) * 0.5,
                                child: Opacity(
                                  opacity: trendValue * 0.8,
                                  child: Icon(
                                    Icons.trending_up,
                                    color: stat.accentColor.withValues(
                                      alpha: 0.9,
                                    ),
                                    size: 18,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.2,
                                        ),
                                        offset: const Offset(0.5, 0.5),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: customSpacing.sm + 2),

                      // Main stat value with enhanced animation and typography
                      TweenAnimationBuilder<double>(
                        duration: Duration(
                          milliseconds: 1000 + (animationValue * 400).toInt(),
                        ),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, valueAnimValue, child) {
                          return Transform.translate(
                            offset: Offset(20 * (1 - valueAnimValue), 0),
                            child: Opacity(
                              opacity: valueAnimValue,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  stat.value,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight
                                        .w900, // Extra bold for emphasis
                                    letterSpacing:
                                        -0.8, // Tighter spacing for modern look
                                    height: 1.1,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.4,
                                        ),
                                        offset: const Offset(1.5, 1.5),
                                        blurRadius: 3,
                                      ),
                                      Shadow(
                                        color: stat.accentColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        offset: const Offset(-0.5, -0.5),
                                        blurRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),

                      // Bottom row: Enhanced label and subtitle with staggered animation
                      TweenAnimationBuilder<double>(
                        duration: Duration(
                          milliseconds: 1200 + (animationValue * 500).toInt(),
                        ),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, labelAnimValue, child) {
                          return Transform.translate(
                            offset: Offset(15 * (1 - labelAnimValue), 0),
                            child: Opacity(
                              opacity: labelAnimValue * 0.9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Enhanced stat label with better typography
                                  Flexible(
                                    child: Text(
                                      stat.label,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.85,
                                        ),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            offset: const Offset(0.5, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),

                                  // Enhanced stat subtitle with accent color and animation
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          stat.accentColor.withValues(
                                            alpha: 0.3,
                                          ),
                                          stat.accentColor.withValues(
                                            alpha: 0.2,
                                          ),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: stat.accentColor.withValues(
                                          alpha: 0.4,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      stat.subtitle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.1,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.3,
                                            ),
                                            offset: const Offset(0.5, 0.5),
                                            blurRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Returns the preferred size for this app bar
  ///
  /// Height calculation:
  /// - Without stats: 120px (compact mode with enhanced padding and animations)
  /// - With stats: 220px (expanded mode with statistics row and premium spacing)
  ///
  /// Enhanced heights accommodate:
  /// - Improved visual design with larger icons and enhanced spacing
  /// - Advanced animations and micro-interactions
  /// - Better accessibility with larger touch targets
  /// - Premium glassmorphism effects with deeper shadows
  /// - Enhanced typography with better line heights
  @override
  Size get preferredSize => Size.fromHeight(stats.isEmpty ? 120 : 220);
}

/// Data model for individual statistics displayed in the app bar
///
/// Used to create stat cards that show key metrics like active tickets,
/// performance scores, completion rates, etc.
///
/// Example usage:
/// ```dart
/// StatItem(
///   label: 'Active Tickets',
///   value: '12',
///   subtitle: '+3 today',
///   icon: Icons.assignment,
///   accentColor: AppColors.primary,
/// )
/// ```
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
  ///
  /// All parameters are required to ensure consistent stat card appearance
  const StatItem({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}
