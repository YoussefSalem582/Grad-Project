import 'package:flutter/material.dart';
import '../../../../widgets/auth/auth.dart';

/// Login screen header widget
class LoginHeader extends StatelessWidget {
  final Animation<double> logoAnimation;
  final Animation<double> formAnimation;

  const LoginHeader({
    super.key,
    required this.logoAnimation,
    required this.formAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 30 : 40),
        LogoWidget(animation: logoAnimation),
        SizedBox(height: isSmallScreen ? 20 : 30),
        WelcomeTextWidget(
          animation: formAnimation,
          title: 'Welcome Back!',
          subtitle: 'Choose your role and sign in to access Emosense',
        ),
        SizedBox(height: isSmallScreen ? 20 : 30),
      ],
    );
  }
}
