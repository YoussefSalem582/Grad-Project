import 'package:flutter/material.dart';

/// App header widget for onboarding screen with app icon
class OnboardingAppHeader extends StatelessWidget {
  const OnboardingAppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // App Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // App Name
          Text(
            'EmoSense',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Tagline
          Text(
            'Emotional Intelligence Platform',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
