import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final Animation<double> animation;
  final double size;

  const LogoWidget({super.key, required this.animation, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Padding(
            padding: EdgeInsets.all(size * 0.10),
            child: Image.asset(
              'assets/images/app_icon.png',
              width: size * 1.2,
              height: size * 1.2,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if image fails to load
                return Icon(
                  Icons.emoji_emotions,
                  size: size * 0.5,
                  color: const Color(0xFF667EEA),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
