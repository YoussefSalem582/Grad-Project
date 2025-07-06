import 'package:flutter/material.dart';
import '../../presentation/screens/screens.dart';

/// Centralized routing configuration
class AppRouter {
  static const String login = '/';
  static const String signup = '/signup';
  static const String roleSelection = '/role-selection';
  static const String adminDashboard = '/admin';
  static const String employeeDashboard = '/employee';
  static const String appStatus = '/status';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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

      default:
        return MaterialPageRoute(
          builder: (_) => const _NotFoundScreen(),
          settings: settings,
        );
    }
  }

  /// Navigation helper methods
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
