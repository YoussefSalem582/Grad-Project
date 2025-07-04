import 'package:flutter/material.dart';
import 'role_selection_widget.dart';
import 'text_field_widget.dart';

class SignUpFormWidget extends StatelessWidget {
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
  final VoidCallback onPasswordToggle;
  final VoidCallback onConfirmPasswordToggle;
  final Animation<double> animation;

  const SignUpFormWidget({
    super.key,
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
    required this.onPasswordToggle,
    required this.onConfirmPasswordToggle,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    RoleSelectionWidget(
                      selectedRole: selectedRole,
                      onRoleChanged: onRoleChanged,
                      title: 'Create account as',
                      roles: [
                        RoleOption(
                          name: 'Employee',
                          icon: Icons.person,
                          description: 'Access employee features',
                          color: const Color(0xFF667EEA),
                        ),
                        RoleOption(
                          name: 'Admin',
                          icon: Icons.admin_panel_settings,
                          description: 'Administrative access',
                          color: const Color(0xFF764BA2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AuthTextFieldWidget(
                            controller: firstNameController,
                            label: 'First Name',
                            hintText: 'Enter your first name',
                            prefixIcon: Icons.person_outline,
                            animation: animation,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'First name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'First name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AuthTextFieldWidget(
                            controller: lastNameController,
                            label: 'Last Name',
                            hintText: 'Enter your last name',
                            prefixIcon: Icons.person_outline,
                            animation: animation,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Last name is required';
                              }
                              if (value.trim().length < 2) {
                                return 'Last name must be at least 2 characters';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AuthTextFieldWidget(
                      controller: emailController,
                      label: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      animation: animation,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    if (selectedRole == 'Employee') ...[
                      const SizedBox(height: 16),
                      AuthTextFieldWidget(
                        controller: employeeIdController,
                        label: 'Employee ID',
                        hintText: 'Enter your employee ID',
                        prefixIcon: Icons.badge_outlined,
                        animation: animation,
                        validator: (value) {
                          if (selectedRole == 'Employee' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Employee ID is required';
                          }
                          if (selectedRole == 'Employee' &&
                              value!.trim().length < 3) {
                            return 'Employee ID must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextFieldWidget(
                        controller: departmentController,
                        label: 'Department',
                        hintText: 'Enter your department',
                        prefixIcon: Icons.business_outlined,
                        animation: animation,
                        validator: (value) {
                          if (selectedRole == 'Employee' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Department is required';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    AuthTextFieldWidget(
                      controller: passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      isPasswordVisible: isPasswordVisible,
                      onPasswordToggle: onPasswordToggle,
                      animation: animation,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                        ).hasMatch(value)) {
                          return 'Password must contain uppercase, lowercase, and numbers';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextFieldWidget(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      isPasswordVisible: isConfirmPasswordVisible,
                      onPasswordToggle: onConfirmPasswordToggle,
                      animation: animation,
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
              ),
            ),
          ),
        );
      },
    );
  }
}
