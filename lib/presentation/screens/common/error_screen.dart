import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A reusable error screen with different error types
class ErrorScreen extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final bool showBackButton;

  const ErrorScreen({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.showBackButton = true,
  });

  // Factory constructors for common error types
  factory ErrorScreen.network({
    String title = 'Connection Error',
    String message = 'Unable to connect to the server. Please check your internet connection and try again.',
    String? actionLabel = 'Retry',
    VoidCallback? onAction,
    String? secondaryActionLabel = 'Settings',
    VoidCallback? onSecondaryAction,
  }) {
    return ErrorScreen(
      title: title,
      message: message,
      icon: Icons.wifi_off,
      actionLabel: actionLabel,
      onAction: onAction,
      secondaryActionLabel: secondaryActionLabel,
      onSecondaryAction: onSecondaryAction,
    );
  }

  factory ErrorScreen.serverError({
    String title = 'Server Error',
    String message = 'Something went wrong on our end. Please try again later.',
    String? actionLabel = 'Retry',
    VoidCallback? onAction,
  }) {
    return ErrorScreen(
      title: title,
      message: message,
      icon: Icons.error_outline,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory ErrorScreen.notFound({
    String title = 'Not Found',
    String message = 'The page you are looking for could not be found.',
    String? actionLabel = 'Go Back',
    VoidCallback? onAction,
  }) {
    return ErrorScreen(
      title: title,
      message: message,
      icon: Icons.search_off,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory ErrorScreen.accessDenied({
    String title = 'Access Denied',
    String message = 'You do not have permission to access this resource.',
    String? actionLabel = 'Login',
    VoidCallback? onAction,
  }) {
    return ErrorScreen(
      title: title,
      message: message,
      icon: Icons.lock_outline,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  factory ErrorScreen.generic({
    String title = 'Something went wrong',
    String message = 'An unexpected error occurred. Please try again.',
    String? actionLabel = 'Retry',
    VoidCallback? onAction,
  }) {
    return ErrorScreen(
      title: title,
      message: message,
      icon: Icons.error_outline,
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
              // Error icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.errorSurface,
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: 60,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(height: 32),

              // Error title
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

              // Error message
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

              // Action buttons
              Column(
                children: [
                  // Primary action button
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

                  // Secondary action button
                  if (secondaryActionLabel != null && onSecondaryAction != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onSecondaryAction,
                        icon: const Icon(Icons.settings),
                        label: Text(secondaryActionLabel!),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
