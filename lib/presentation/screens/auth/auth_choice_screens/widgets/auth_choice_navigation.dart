import 'package:flutter/material.dart';

/// Auth choice navigation widget (back button)
class AuthChoiceNavigation extends StatelessWidget {
  final VoidCallback onBackPressed;
  final Animation<double> fadeAnimation;

  const AuthChoiceNavigation({
    super.key,
    required this.onBackPressed,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            onPressed: onBackPressed,
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            tooltip: 'Back to Onboarding',
          ),
        ),
      ),
    );
  }
}
