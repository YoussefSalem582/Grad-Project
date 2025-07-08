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

  static void toAppStatus(BuildContext context) {
    Navigator.pushNamed(context, appStatus);
  }

  static void toTestBackend(BuildContext context) {
    Navigator.pushNamed(context, testBackend);
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
