import 'package:flutter/material.dart';
import 'auth_choice_header.dart';
import 'auth_choice_buttons.dart';
import 'auth_choice_navigation.dart';
import '../../../../widgets/common/animated_background_widget.dart';

/// Main content widget for the auth choice screen
class AuthChoiceContent extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final Animation<double> cardScaleAnimation;
  final Animation<double> backgroundAnimation;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;
  final VoidCallback onBackPressed;

  const AuthChoiceContent({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.cardScaleAnimation,
    required this.backgroundAnimation,
    required this.onLoginPressed,
    required this.onSignUpPressed,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background
        AnimatedBackgroundWidget(animation: backgroundAnimation),

        // Main content
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 80),

              // Header
              AuthChoiceHeader(
                fadeAnimation: fadeAnimation,
                slideAnimation: slideAnimation,
              ),

              const Spacer(),

              // Auth choice buttons
              AuthChoiceButtons(
                cardScaleAnimation: cardScaleAnimation,
                onLoginPressed: onLoginPressed,
                onSignUpPressed: onSignUpPressed,
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),

        // Back button
        AuthChoiceNavigation(
          onBackPressed: onBackPressed,
          fadeAnimation: fadeAnimation,
        ),
      ],
    );
  }
}
