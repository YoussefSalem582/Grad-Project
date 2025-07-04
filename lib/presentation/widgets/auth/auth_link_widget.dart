import 'package:flutter/material.dart';

class AuthLinkWidget extends StatelessWidget {
  final Animation<double> animation;
  final String leadingText;
  final String linkText;
  final VoidCallback onPressed;
  final Color textColor;
  final Color linkColor;

  const AuthLinkWidget({
    super.key,
    required this.animation,
    required this.leadingText,
    required this.linkText,
    required this.onPressed,
    this.textColor = Colors.white,
    this.linkColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                leadingText,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  linkText,
                  style: TextStyle(
                    color: linkColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: linkColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
