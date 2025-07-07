import 'package:flutter/material.dart';

/// Data class for onboarding page content
class OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
