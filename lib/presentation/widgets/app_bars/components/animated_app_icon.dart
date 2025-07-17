import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// An animated app icon widget that displays the app icon from assets
/// with scaling and rotation animations.
class AnimatedAppIcon extends StatelessWidget {
  /// Custom accessibility label for the icon (optional)
  final String? semanticLabel;

  /// Custom spacing configuration
  final CustomSpacing customSpacing;

  const AnimatedAppIcon({
    super.key,
    this.semanticLabel,
    required this.customSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.7 + (0.3 * value), // Scale from 70% to 100%
          child: Transform.rotate(
            angle: (1 - value) * 0.5, // Slight rotation during animation
            child: Semantics(
              label: semanticLabel ?? 'App icon',
              child: Container(
                padding: EdgeInsets.all(customSpacing.sm + 2),
                decoration: BoxDecoration(
                  // Multi-layer glassmorphism effect with enhanced gradients
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2.5,
                  ),
                  boxShadow: [
                    // Inner light shadow
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(-3, -3),
                      spreadRadius: 1,
                    ),
                    // Outer dark shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                      spreadRadius: 1,
                    ),
                    // Ambient shadow
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                      spreadRadius: -3,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(customSpacing.xs + 2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to default icon if asset fails to load
                        return Icon(
                          Icons.emoji_emotions,
                          color: Colors.white,
                          size: 32,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              offset: const Offset(1.5, 1.5),
                              blurRadius: 3,
                            ),
                            Shadow(
                              color: Colors.white.withValues(alpha: 0.2),
                              offset: const Offset(-0.5, -0.5),
                              blurRadius: 1,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
