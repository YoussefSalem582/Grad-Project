import 'package:flutter/material.dart';
import '../../../../widgets/auth/auth.dart';

/// Login footer widget with social login and navigation options
class LoginFooter extends StatelessWidget {
  final Animation<double> formAnimation;
  final String selectedRole;
  final VoidCallback onLogin;
  final bool isLoading;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final Function(String) onSocialLogin;
  final VoidCallback onNavigateToSignUp;

  const LoginFooter({
    super.key,
    required this.formAnimation,
    required this.selectedRole,
    required this.onLogin,
    required this.isLoading,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    required this.onSocialLogin,
    required this.onNavigateToSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 20 : 25),
        AuthButtonWidget(
          animation: formAnimation,
          onPressed: onLogin,
          text: 'Sign in as $selectedRole',
          isLoading: isLoading,
          icon:
              selectedRole == 'Admin'
                  ? Icons.admin_panel_settings
                  : Icons.person,
          gradientColors:
              selectedRole == 'Admin'
                  ? [const Color(0xFF764BA2), const Color(0xFF667EEA)]
                  : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        ),
        SizedBox(height: isSmallScreen ? 10 : 15),
        RememberMeWidget(
          animation: formAnimation,
          value: rememberMe,
          onChanged: onRememberMeChanged,
          onForgotPassword: onForgotPassword,
        ),
        SizedBox(height: isSmallScreen ? 20 : 30),
        DividerWidget(animation: formAnimation),
        SizedBox(height: isSmallScreen ? 20 : 25),
        SocialLoginWidget(
          animation: formAnimation,
          buttons: [
            SocialLoginButton(
              text: 'Google',
              icon: Icons.g_mobiledata,
              textColor: Colors.white,
              backgroundColor: const Color(0xFFDB4437),
              onPressed: () => onSocialLogin('google'),
            ),
            SocialLoginButton(
              text: 'Microsoft',
              icon: Icons.business,
              textColor: Colors.white,
              backgroundColor: const Color(0xFF00A4EF),
              onPressed: () => onSocialLogin('microsoft'),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 20 : 25),
        AuthLinkWidget(
          animation: formAnimation,
          leadingText: "Don't have an account? ",
          linkText: 'Sign Up',
          onPressed: onNavigateToSignUp,
        ),
        SizedBox(height: isSmallScreen ? 30 : 40),
      ],
    );
  }
}
