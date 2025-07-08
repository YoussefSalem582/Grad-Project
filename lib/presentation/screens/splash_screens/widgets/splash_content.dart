import 'package:flutter/material.dart';
import 'splash_logo.dart';
import 'splash_text.dart';
import 'splash_background.dart';

/// Main content widget for the splash screen
class SplashContent extends StatelessWidget {
  final Animation<double> logoScaleAnimation;
  final Animation<double> logoRotationAnimation;
  final Animation<double> textFadeAnimation;
  final Animation<Offset> textSlideAnimation;
  final Animation<double> backgroundAnimation;
  final Animation<double> particleAnimation;

  const SplashContent({
    super.key,
    required this.logoScaleAnimation,
    required this.logoRotationAnimation,
    required this.textFadeAnimation,
    required this.textSlideAnimation,
    required this.backgroundAnimation,
    required this.particleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background
        SplashBackground(
          backgroundAnimation: backgroundAnimation,
          particleAnimation: particleAnimation,
        ),

        // Main content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              SplashLogo(
                scaleAnimation: logoScaleAnimation,
                rotationAnimation: logoRotationAnimation,
              ),

              const SizedBox(height: 40),

              // Text
              SplashText(
                fadeAnimation: textFadeAnimation,
                slideAnimation: textSlideAnimation,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
