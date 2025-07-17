import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.dart';

/// A notification button with advanced badge system for unread notifications
class AppBarNotificationButton extends StatelessWidget {
  /// Callback function for notification button press
  final VoidCallback onPressed;

  /// Whether to show an unread notification indicator (red dot)
  final bool hasUnreadNotifications;

  /// Number of unread notifications to display in badge (optional)
  /// When null, shows only a simple red dot indicator
  final int? notificationCount;

  /// Custom spacing configuration
  final CustomSpacing customSpacing;

  const AppBarNotificationButton({
    super.key,
    required this.onPressed,
    required this.hasUnreadNotifications,
    this.notificationCount,
    required this.customSpacing,
  });

  @override
  Widget build(BuildContext context) {
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
                      onPressed();
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
                    child:
                        notificationCount != null && notificationCount! > 0
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
}
