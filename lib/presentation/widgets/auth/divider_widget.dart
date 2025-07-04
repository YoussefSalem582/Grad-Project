import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  final Animation<double> animation;
  final String text;
  final Color color;
  final double opacity;

  const DividerWidget({
    super.key,
    required this.animation,
    this.text = 'OR',
    this.color = Colors.white,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: color.withValues(alpha: opacity),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: color.withValues(alpha: opacity),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
