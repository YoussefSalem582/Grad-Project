import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing onboarding-related persistent data
class OnboardingPreferences {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _onboardingVersionKey = 'onboarding_version';

  // Current onboarding version - increment this when onboarding content changes
  static const int currentOnboardingVersion = 1;

  /// Check if onboarding has been completed for the current version
  static Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
      final version = prefs.getInt(_onboardingVersionKey) ?? 0;

      // Return true only if onboarding is completed AND version matches current
      return isCompleted && version >= currentOnboardingVersion;
    } catch (e) {
      // If there's an error reading preferences, assume onboarding not completed
      return false;
    }
  }

  /// Mark onboarding as completed for the current version
  static Future<bool> setOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      await prefs.setInt(_onboardingVersionKey, currentOnboardingVersion);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Reset onboarding status (useful for testing or user preference)
  static Future<bool> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, false);
      await prefs.setInt(_onboardingVersionKey, 0);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the version of the last completed onboarding
  static Future<int> getCompletedOnboardingVersion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_onboardingVersionKey) ?? 0;
    } catch (e) {
      return 0;
    }
  }

  /// Check if the user should see onboarding (considering version changes)
  static Future<bool> shouldShowOnboarding() async {
    return !(await isOnboardingCompleted());
  }
}
