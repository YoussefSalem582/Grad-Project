import 'package:flutter/material.dart';
import '../../services/onboarding_preferences.dart';

/// Developer utility widget for testing onboarding flow
/// This widget provides easy access to reset onboarding status for testing purposes
class OnboardingDeveloperTools extends StatefulWidget {
  const OnboardingDeveloperTools({Key? key}) : super(key: key);

  @override
  State<OnboardingDeveloperTools> createState() =>
      _OnboardingDeveloperToolsState();
}

class _OnboardingDeveloperToolsState extends State<OnboardingDeveloperTools> {
  bool _isOnboardingCompleted = false;
  int _onboardingVersion = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    setState(() => _isLoading = true);

    final isCompleted = await OnboardingPreferences.isOnboardingCompleted();
    final version = await OnboardingPreferences.getCompletedOnboardingVersion();

    setState(() {
      _isOnboardingCompleted = isCompleted;
      _onboardingVersion = version;
      _isLoading = false;
    });
  }

  Future<void> _resetOnboarding() async {
    setState(() => _isLoading = true);

    final success = await OnboardingPreferences.resetOnboarding();

    if (success) {
      _showSnackBar('Onboarding status reset successfully');
      await _loadOnboardingStatus();
    } else {
      _showSnackBar('Failed to reset onboarding status');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setOnboardingCompleted() async {
    setState(() => _isLoading = true);

    final success = await OnboardingPreferences.setOnboardingCompleted();

    if (success) {
      _showSnackBar('Onboarding marked as completed');
      await _loadOnboardingStatus();
    } else {
      _showSnackBar('Failed to mark onboarding as completed');
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.developer_mode, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Onboarding Developer Tools',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              // Status information
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Status:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _isOnboardingCompleted
                              ? Icons.check_circle
                              : Icons.cancel,
                          color:
                              _isOnboardingCompleted
                                  ? Colors.green
                                  : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isOnboardingCompleted
                              ? 'Completed'
                              : 'Not Completed',
                          style: TextStyle(
                            color:
                                _isOnboardingCompleted
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version: $_onboardingVersion / ${OnboardingPreferences.currentOnboardingVersion}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetOnboarding,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _setOnboardingCompleted,
                      icon: const Icon(Icons.check),
                      label: const Text('Mark Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Refresh button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _loadOnboardingStatus,
                  icon: const Icon(Icons.sync),
                  label: const Text('Refresh Status'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
