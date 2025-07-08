import 'package:flutter/material.dart';
import '../../../../widgets/auth/auth.dart';

/// Signup form widget
class SignupForm extends StatelessWidget {
  final Animation<double> formAnimation;
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController employeeIdController;
  final TextEditingController departmentController;
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final VoidCallback onConfirmPasswordVisibilityToggle;

  const SignupForm({
    super.key,
    required this.formAnimation,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.employeeIdController,
    required this.departmentController,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.onPasswordVisibilityToggle,
    required this.onConfirmPasswordVisibilityToggle,
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
                description: 'Register as an employee',
                color: Color(0xFF667EEA),
              ),
              RoleOption(
                name: 'Admin',
                icon: Icons.admin_panel_settings_outlined,
                description: 'Register as an admin',
                color: Color(0xFF764BA2),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: AuthTextField(
                  controller: firstNameController,
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AuthTextField(
                  controller: lastNameController,
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
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
          if (selectedRole == 'Employee') ...[
            AuthTextField(
              controller: employeeIdController,
              labelText: 'Employee ID',
              hintText: 'Enter your employee ID',
              prefixIcon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your employee ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            AuthTextField(
              controller: departmentController,
              labelText: 'Department',
              hintText: 'Enter your department',
              prefixIcon: Icons.business_outlined,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your department';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
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
          const SizedBox(height: 20),
          AuthTextField(
            controller: confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: !isConfirmPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isConfirmPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: onConfirmPasswordVisibilityToggle,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
