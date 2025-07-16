import 'package:flutter/material.dart';
import '../common/animated_loading_indicator.dart';

class AuthButtonWidget extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final IconData? icon;
  final List<Color> gradientColors;
  final double height;
  final double borderRadius;

  const AuthButtonWidget({
    super.key,
    required this.animation,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.gradientColors = const [Color(0xFF667EEA), Color(0xFF764BA2)],
    this.height = 80,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors.first.withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child:
                        isLoading
                            ? EmoLoader.mini(size: 32, color: Colors.white)
                            : _buildButtonContent(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonContent() {
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}
