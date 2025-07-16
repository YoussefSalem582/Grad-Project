import 'package:flutter/material.dart';
import '../../presentation/screens/screens.dart';
import '../../screens/test_backend_screen.dart';

/// Centralized routing configuration
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String authChoice = '/auth-choice';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String roleSelection = '/role-selection';
  static const String adminDashboard = '/admin';
  static const String employeeDashboard = '/employee';
  static const String appStatus = '/status';
  static const String testBackend = '/test-backend';
  static const String loading = '/loading';
  static const String error = '/error';
  static const String emptyState = '/empty-state';

  // Analysis tool routes
  static const String textAnalysis = '/text-analysis';
  static const String voiceAnalysis = '/voice-analysis';
  static const String videoAnalysis = '/video-analysis';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      case authChoice:
        return MaterialPageRoute(
          builder: (_) => const AuthChoiceScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );

      case adminDashboard:
        return MaterialPageRoute(
          builder: (_) => const AdminNavigationScreen(),
          settings: settings,
        );

      case employeeDashboard:
        return MaterialPageRoute(
          builder: (_) => const EmployeeNavigationScreen(),
          settings: settings,
        );

      case testBackend:
        return MaterialPageRoute(
          builder: (_) => const TestBackendScreen(),
          settings: settings,
        );

      case loading:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => LoadingScreen(
                message: args?['message'] ?? 'Loading...',
                showProgress: args?['showProgress'] ?? false,
                progress: args?['progress'],
              ),
          settings: settings,
        );

      case error:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => ErrorScreen(
                title: args?['title'] ?? 'Error',
                message: args?['message'] ?? 'Something went wrong',
                icon: args?['icon'],
                actionLabel: args?['actionLabel'],
                onAction: args?['onAction'],
              ),
          settings: settings,
        );

      case emptyState:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder:
              (_) => EmptyStateScreen(
                title: args?['title'] ?? 'No Data',
                message: args?['message'] ?? 'No data available',
                icon: args?['icon'],
                actionLabel: args?['actionLabel'],
                onAction: args?['onAction'],
              ),
          settings: settings,
        );

      case textAnalysis:
        return MaterialPageRoute(
          builder: (_) => const UnifiedTextAnalysisScreen(),
          settings: settings,
        );

      case voiceAnalysis:
        return MaterialPageRoute(
          builder: (_) => const UnifiedVoiceAnalysisScreen(),
          settings: settings,
        );

      case videoAnalysis:
        return MaterialPageRoute(
          builder: (_) => const EmployeeVideoAnalysisScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundScreen(),
          settings: settings,
        );
    }
  }

  /// Navigation helper methods
  static void toSplash(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, splash, (route) => false);
  }

  static void toOnboarding(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, onboarding, (route) => false);
  }

  static void toAuthChoice(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, authChoice, (route) => false);
  }

  static void toLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
  }

  static void toRoleSelection(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, roleSelection, (route) => false);
  }

  static void toAdminDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, adminDashboard);
  }

  static void toEmployeeDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, employeeDashboard);
  }

  static void toTextAnalysis(BuildContext context) {
    Navigator.pushNamed(context, textAnalysis);
  }

  static void toVoiceAnalysis(BuildContext context) {
    Navigator.pushNamed(context, voiceAnalysis);
  }

  static void toVideoAnalysis(BuildContext context) {
    Navigator.pushNamed(context, videoAnalysis);
  }

  static void toAppStatus(BuildContext context) {
    Navigator.pushNamed(context, appStatus);
  }

  static void toTestBackend(BuildContext context) {
    Navigator.pushNamed(context, testBackend);
  }

  // Helper methods for common screens
  static void toLoading(
    BuildContext context, {
    String message = 'Loading...',
    bool showProgress = false,
    double? progress,
  }) {
    Navigator.pushNamed(
      context,
      loading,
      arguments: {
        'message': message,
        'showProgress': showProgress,
        'progress': progress,
      },
    );
  }

  static void showError(
    BuildContext context, {
    String title = 'Error',
    String message = 'Something went wrong',
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Navigator.pushNamed(
      context,
      error,
      arguments: {
        'title': title,
        'message': message,
        'icon': icon,
        'actionLabel': actionLabel,
        'onAction': onAction,
      },
    );
  }

  static void showEmptyState(
    BuildContext context, {
    String title = 'No Data',
    String message = 'No data available',
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    Navigator.pushNamed(
      context,
      emptyState,
      arguments: {
        'title': title,
        'message': message,
        'icon': icon,
        'actionLabel': actionLabel,
        'onAction': onAction,
      },
    );
  }

  // Enhanced navigation utilities
  static Future<T?> pushAndClearStack<T extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64),
            SizedBox(height: 16),
            Text(
              '404 - Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('The page you are looking for does not exist.'),
          ],
        ),
      ),
    );
  }
}
