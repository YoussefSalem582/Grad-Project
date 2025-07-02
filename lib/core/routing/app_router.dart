import 'package:flutter/material.dart';
import '../../presentation/screens/screens.dart';

/// Centralized routing configuration
class AppRouter {
  static const String mainDashboard = '/';
  static const String appStatus = '/status';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainDashboard:
        return MaterialPageRoute(
          builder: (_) => const AppNavigationScreen(),
          settings: settings,
        );

      case appStatus:
        return MaterialPageRoute(
          builder: (_) => const AppStatusScreen(),
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
  static void toMainDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, mainDashboard, (route) => false);
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
