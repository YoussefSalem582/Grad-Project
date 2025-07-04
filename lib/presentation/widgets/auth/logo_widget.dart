import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final IconData icon;
  final Color iconColor;

  const LogoWidget({
    super.key,
    required this.animation,
    this.size = 100,
    this.icon = Icons.emoji_emotions,
    this.iconColor = const Color(0xFF667EEA),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF8F9FA)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Icon(icon, size: size * 0.5, color: iconColor),
          ),
        );
      },
    );
  }
}
