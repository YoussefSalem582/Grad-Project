import 'package:flutter/material.dart';

/// Advanced animated background effects for the app bar
class AppBarBackgroundEffects extends StatelessWidget {
  const AppBarBackgroundEffects({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Advanced animated background pattern with shimmer effect
        Positioned.fill(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 4000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1.0 + 2.0 * value, -1.0),
                    end: Alignment(1.0 + 2.0 * value, 1.0),
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.15 * value),
                      Colors.white.withValues(alpha: 0.1 * value),
                      Colors.white.withValues(alpha: 0.05 * value),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              );
            },
          ),
        ),

        // Subtle noise texture overlay for premium feel
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.02),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
