import 'package:flutter/material.dart';
import '../../../../widgets/auth/auth.dart';

/// Signup screen header widget
class SignupHeader extends StatelessWidget {
  final Animation<double> formAnimation;

  const SignupHeader({super.key, required this.formAnimation});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 20 : 30),
        WelcomeTextWidget(
          animation: formAnimation,
          title: 'Create Account',
          subtitle: 'Join Emosense and start your journey',
        ),
        SizedBox(height: isSmallScreen ? 20 : 30),
      ],
    );
  }
}
