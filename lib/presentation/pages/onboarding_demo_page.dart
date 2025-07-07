import 'package:flutter/material.dart';
import '../widgets/developer/onboarding_developer_tools.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/onboarding_screens/onboarding_screen.dart';
import '../screens/auth/auth_choice_screen.dart';

/// Demo page for testing onboarding flow and developer tools
class OnboardingDemoPage extends StatelessWidget {
  const OnboardingDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Onboarding Demo'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page header
            Text(
              'Onboarding Flow Demo',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Test the onboarding flow and manage onboarding preferences.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            // Developer tools
            const OnboardingDeveloperTools(),

            const SizedBox(height: 24),

            // Demo actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Demo Actions',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Action buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _navigateToSplash(context),
                        icon: const Icon(Icons.screen_lock_landscape),
                        label: const Text('Test Splash Screen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToOnboarding(context),
                        icon: const Icon(Icons.explore),
                        label: const Text('Test Onboarding Flow'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToAuthChoice(context),
                        icon: const Icon(Icons.login),
                        label: const Text('Test Auth Choice Screen'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.purple.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Information card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(
                          'How it Works',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      '1. The splash screen checks onboarding completion status\n'
                      '2. If not completed, it shows the onboarding flow\n'
                      '3. After onboarding, users see the auth choice screen\n'
                      '4. If onboarding was already completed, it goes directly to auth choice\n'
                      '5. Users can choose between Sign In or Sign Up\n'
                      '6. Onboarding completion is persisted using SharedPreferences\n'
                      '7. Version tracking prevents showing outdated onboarding',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSplash(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  void _navigateToOnboarding(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  void _navigateToAuthChoice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AuthChoiceScreen()),
    );
  }
}
