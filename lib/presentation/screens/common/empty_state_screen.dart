import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A screen that shows when there's no data to display
class EmptyStateScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customContent;
  final bool showBackButton;

  const EmptyStateScreen({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.customContent,
    this.showBackButton = false,
  });

  // Factory constructors for common empty states
  factory EmptyStateScreen.noData({
    String title = 'No Data Available',
    String message = 'There is no data to display at the moment.',
    String? actionLabel = 'Refresh',
    VoidCallback? onAction,
  }) {
    return EmptyStateScreen(
      title: title,
      message: message,
      icon: Icons.inbox_outlined,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory EmptyStateScreen.noResults({
    String title = 'No Results Found',
    String message = 'No results match your search criteria. Try adjusting your filters.',
    String? actionLabel = 'Clear Filters',
    VoidCallback? onAction,
  }) {
    return EmptyStateScreen(
      title: title,
      message: message,
      icon: Icons.search_off,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory EmptyStateScreen.noNotifications({
    String title = 'No Notifications',
    String message = 'You have no new notifications at the moment.',
    String? actionLabel = 'Refresh',
    VoidCallback? onAction,
  }) {
    return EmptyStateScreen(
      title: title,
      message: message,
      icon: Icons.notifications_off_outlined,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory EmptyStateScreen.noAnalytics({
    String title = 'No Analytics Data',
    String message = 'No analytics data available for the selected period.',
    String? actionLabel = 'Change Period',
    VoidCallback? onAction,
  }) {
    return EmptyStateScreen(
      title: title,
      message: message,
      icon: Icons.analytics_outlined,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory EmptyStateScreen.comingSoon({
    String title = 'Coming Soon',
    String message = 'This feature is under development. Stay tuned for updates!',
  }) {
    return EmptyStateScreen(
      title: title,
      message: message,
      icon: Icons.construction_outlined,
    );
  }

  factory EmptyStateScreen.maintenance({
    String title = 'Under Maintenance',
    String message = 'This feature is temporarily unavailable due to maintenance.',
    String? actionLabel = 'Check Status',
    VoidCallback? onAction,
  }) {
    return EmptyStateScreen(
      title: title,
      message: message,
      icon: Icons.build_outlined,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: showBackButton
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (customContent != null) ...[
                customContent!,
              ] else ...[
                // Default empty state design
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainer,
                    border: Border.all(
                      color: AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon ?? Icons.inbox_outlined,
                    size: 60,
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Action button (if provided)
                if (actionLabel != null && onAction != null) ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.refresh),
                      label: Text(actionLabel!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
