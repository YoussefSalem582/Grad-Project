import 'package:flutter/material.dart';

/// Splash screen background with animated effects
class SplashBackground extends StatelessWidget {
  final Animation<double> backgroundAnimation;
  final Animation<double> particleAnimation;

  const SplashBackground({
    super.key,
    required this.backgroundAnimation,
    required this.particleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([backgroundAnimation, particleAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFFF8F9FF),
                  const Color(0xFFE3F2FD),
                  backgroundAnimation.value,
                )!,
                Color.lerp(
                  const Color(0xFFF0F4FF),
                  const Color(0xFFE8EAF6),
                  backgroundAnimation.value,
                )!,
                Color.lerp(
                  const Color(0xFFE8F2FF),
                  const Color(0xFFF3E5F5),
                  backgroundAnimation.value,
                )!,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Enhanced particle effects with varied sizes and colors
              ...List.generate(25, (index) {
                final double offset = (index * 0.1) % 1.0;
                final double size = 1.5 + (index % 4) * 0.8;
                final double left = (index * 60.0) % MediaQuery.of(context).size.width;
                final double initialTop = (index * 90.0) % MediaQuery.of(context).size.height;
                
                // Different particle colors for variety
                final Color particleColor = [
                  Colors.blue.withValues(alpha: 0.4),
                  Colors.purple.withValues(alpha: 0.3),
                  Colors.indigo.withValues(alpha: 0.35),
                  Colors.teal.withValues(alpha: 0.25),
                ][index % 4];

                return AnimatedPositioned(
                  duration: Duration(milliseconds: 800 + (index * 30)),
                  left: left + (particleAnimation.value * 20 * (index % 2 == 0 ? 1 : -1)),
                  top: initialTop + (particleAnimation.value * 150 * (1 + offset)),
                  child: Opacity(
                    opacity: (0.4 * (1 - particleAnimation.value * 0.7)) * 
                           (0.5 + 0.5 * backgroundAnimation.value),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: particleColor,
                        boxShadow: [
                          BoxShadow(
                            color: particleColor.withValues(alpha: 0.2),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              // Add some larger floating elements
              ...List.generate(8, (index) {
                final double size = 8.0 + (index % 3) * 4.0;
                final double left = (index * 80.0) % MediaQuery.of(context).size.width;
                final double top = (index * 120.0) % MediaQuery.of(context).size.height;
                
                return AnimatedPositioned(
                  duration: Duration(milliseconds: 1200 + (index * 100)),
                  left: left + (particleAnimation.value * 30 * (index % 2 == 0 ? 1 : -1)),
                  top: top + (particleAnimation.value * 80 * (1 + (index * 0.1))),
                  child: Opacity(
                    opacity: (0.15 * (1 - particleAnimation.value * 0.5)) * 
                           backgroundAnimation.value,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.6),
                            Colors.blue.withValues(alpha: 0.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
