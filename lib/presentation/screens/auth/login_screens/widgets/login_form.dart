import 'package:flutter/material.dart';
import '../../../../widgets/auth/auth.dart';

/// Login form widget
class LoginForm extends StatelessWidget {
  final Animation<double> formAnimation;
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final bool isPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const LoginForm({
    super.key,
    required this.formAnimation,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.isPasswordVisible,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AuthFormWidget(
      animation: formAnimation,
      formKey: formKey,
      child: Column(
        children: [
          RoleSelectionWidget(
            selectedRole: selectedRole,
            onRoleChanged: onRoleChanged,
            roles: const [
              RoleOption(
                name: 'Employee',
                icon: Icons.person_outline,
                description: 'Access employee dashboard',
                color: Color(0xFF667EEA),
              ),
              RoleOption(
                name: 'Admin',
                icon: Icons.admin_panel_settings_outlined,
                description: 'Access admin panel',
                color: Color(0xFF764BA2),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AuthTextField(
            controller: emailController,
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          AuthTextField(
            controller: passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onPasswordVisibilityToggle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
