import 'package:flutter/material.dart';

class SocialLoginWidget extends StatelessWidget {
  final Animation<double> animation;
  final List<SocialLoginButton> buttons;

  const SocialLoginWidget({
    super.key,
    required this.animation,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Row(
            children: buttons
                .map(
                  (button) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: button != buttons.last ? 16 : 0,
                      ),
                      child: SocialButton(
                        text: button.text,
                        icon: button.icon,
                        textColor: button.textColor,
                        backgroundColor: button.backgroundColor,
                        onPressed: button.onPressed,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double height;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 20),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}

class SocialLoginButton {
  final String text;
  final IconData icon;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const SocialLoginButton({
    required this.text,
    required this.icon,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
  });
}
