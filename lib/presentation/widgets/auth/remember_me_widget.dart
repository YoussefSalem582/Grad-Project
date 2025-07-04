import 'package:flutter/material.dart';

class RememberMeWidget extends StatelessWidget {
  final Animation<double> animation;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onForgotPassword;
  final String rememberText;
  final String forgotPasswordText;

  const RememberMeWidget({
    super.key,
    required this.animation,
    required this.value,
    required this.onChanged,
    this.onForgotPassword,
    this.rememberText = 'Remember me',
    this.forgotPasswordText = 'Forgot Password?',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: value,
                      onChanged: (newValue) => onChanged(newValue ?? false),
                      activeColor: const Color(0xFF667EEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      rememberText,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (onForgotPassword != null)
                  TextButton(
                    onPressed: onForgotPassword,
                    child: Text(
                      forgotPasswordText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
