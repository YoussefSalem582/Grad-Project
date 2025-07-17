import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// A status indicator showing employee availability with pulsing animation
class AppBarStatusIndicator extends StatelessWidget {
  final bool isAvailable;
  final CustomSpacing customSpacing;

  const AppBarStatusIndicator({
    super.key,
    required this.isAvailable,
    required this.customSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Continuous pulsing ripple effect
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 2000),
                    builder: (context, pulse, child) {
                      return AnimatedBuilder(
                        animation: AlwaysStoppedAnimation(pulse),
                        builder: (context, child) {
                          final pulseScale = 1.0 + (pulse * 0.3);
                          return Transform.scale(
                            scale: pulseScale,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isAvailable
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFFF5722))
                                    .withValues(alpha: 0.3 * (1.0 - pulse)),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // Main status dot
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isAvailable
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFFF5722),
                      boxShadow: [
                        BoxShadow(
                          color: (isAvailable
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFFFF5722))
                              .withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
