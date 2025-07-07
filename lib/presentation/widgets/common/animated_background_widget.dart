import 'package:flutter/material.dart';

class AnimatedBackgroundWidget extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedBackgroundWidget({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
                Color(0xFF48CAE4),
                Color(0xFF667EEA),
              ],
              stops: [
                0.0 + (0.1 * animation.value),
                0.3 + (0.1 * animation.value),
                0.7 + (0.1 * animation.value),
                1.0,
              ],
            ),
          ),
          child: Stack(
            children: [
              _buildFloatingCircle(
                top: 100 + (20 * animation.value),
                right: 50 + (30 * animation.value),
                size: 80,
                opacity: 0.1,
              ),
              _buildFloatingCircle(
                bottom: 200 + (40 * animation.value),
                left: 30 + (20 * animation.value),
                size: 120,
                opacity: 0.08,
              ),
              _buildFloatingCircle(
                top: 300 + (15 * animation.value),
                left: 200 + (25 * animation.value),
                size: 60,
                opacity: 0.12,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
