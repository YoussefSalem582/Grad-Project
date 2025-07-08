import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../presentation/screens/common/common_screens.dart';

/// Enum for different screen states
enum ScreenState {
  initial,
  loading,
  loaded,
  error,
  empty,
  noNetwork,
}

/// A widget that manages different screen states
class ScreenStateManager extends StatelessWidget {
  final ScreenState state;
  final Widget child;
  final String loadingMessage;
  final String errorTitle;
  final String errorMessage;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onRefresh;
  final bool showProgress;
  final double? progress;

  const ScreenStateManager({
    super.key,
    required this.state,
    required this.child,
    this.loadingMessage = 'Loading...',
    this.errorTitle = 'Error',
    this.errorMessage = 'Something went wrong',
    this.emptyTitle = 'No Data',
    this.emptyMessage = 'No data available',
    this.onRetry,
    this.onRefresh,
    this.showProgress = false,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case ScreenState.initial:
      case ScreenState.loaded:
        return child;

      case ScreenState.loading:
        return LoadingScreen(
          message: loadingMessage,
          showProgress: showProgress,
          progress: progress,
        );

      case ScreenState.error:
        return ErrorScreen.generic(
          title: errorTitle,
          message: errorMessage,
          actionLabel: onRetry != null ? 'Retry' : null,
          onAction: onRetry,
        );

      case ScreenState.empty:
        return EmptyStateScreen.noData(
          title: emptyTitle,
          message: emptyMessage,
          actionLabel: onRefresh != null ? 'Refresh' : null,
          onAction: onRefresh,
        );

      case ScreenState.noNetwork:
        return ErrorScreen.network(
          onAction: onRetry,
        );
    }
  }
}

/// A mixin for managing screen states in StatefulWidgets
mixin ScreenStateMixin<T extends StatefulWidget> on State<T> {
  ScreenState _currentState = ScreenState.initial;
  String _loadingMessage = 'Loading...';
  String _errorMessage = 'Something went wrong';
  String _emptyMessage = 'No data available';

  ScreenState get currentState => _currentState;
  String get loadingMessage => _loadingMessage;
  String get errorMessage => _errorMessage;
  String get emptyMessage => _emptyMessage;

  void setLoading({String message = 'Loading...'}) {
    if (mounted) {
      setState(() {
        _currentState = ScreenState.loading;
        _loadingMessage = message;
      });
    }
  }

  void setLoaded() {
    if (mounted) {
      setState(() {
        _currentState = ScreenState.loaded;
      });
    }
  }

  void setError({String message = 'Something went wrong'}) {
    if (mounted) {
      setState(() {
        _currentState = ScreenState.error;
        _errorMessage = message;
      });
    }
  }

  void setEmpty({String message = 'No data available'}) {
    if (mounted) {
      setState(() {
        _currentState = ScreenState.empty;
        _emptyMessage = message;
      });
    }
  }

  void setNoNetwork() {
    if (mounted) {
      setState(() {
        _currentState = ScreenState.noNetwork;
      });
    }
  }

  void setInitial() {
    if (mounted) {
      setState(() {
        _currentState = ScreenState.initial;
      });
    }
  }

  Widget buildWithState({
    required Widget child,
    VoidCallback? onRetry,
    VoidCallback? onRefresh,
    bool showProgress = false,
    double? progress,
  }) {
    return ScreenStateManager(
      state: _currentState,
      child: child,
      loadingMessage: _loadingMessage,
      errorMessage: _errorMessage,
      emptyMessage: _emptyMessage,
      onRetry: onRetry,
      onRefresh: onRefresh,
      showProgress: showProgress,
      progress: progress,
    );
  }
}

/// A utility class for common screen actions
class ScreenActions {
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor ?? Colors.white),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: textColor ?? Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? AppColors.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static void showSuccessSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
    );
  }

  static void showWarningSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_outlined,
    );
  }

  static void showInfoSnackBar(BuildContext context, String message) {
    showSnackBar(
      context,
      message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline,
    );
  }

  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: confirmColor ?? AppColors.primary),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor ?? AppColors.primary,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
