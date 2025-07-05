import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/auth/auth.dart';
import '../../../core/routing/app_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _departmentController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  String _selectedRole = 'Employee'; // Default role

  late AnimationController _formController;
  late AnimationController _backgroundController;
  late Animation<double> _formAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _formAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _formController.dispose();
    _backgroundController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _employeeIdController.dispose();
    _departmentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the terms and conditions'),
          backgroundColor: Colors.red.withValues(alpha: 0.9),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate sign-up process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome ${_firstNameController.text}! Account created successfully.',
            ),
            backgroundColor: Colors.green.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate to appropriate dashboard based on role
        if (_selectedRole == 'Admin') {
          AppRouter.toAdminDashboard(context);
        } else {
          AppRouter.toEmployeeDashboard(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
            backgroundColor: Colors.red.withValues(alpha: 0.9),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            AnimatedBackgroundWidget(animation: _backgroundAnimation),
            _buildScrollableContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final screenHeight = MediaQuery.of(context).size.height;
          final isSmallScreen = screenHeight < 700;

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - keyboardHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16.0 : 24.0,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: isSmallScreen ? 10 : 20),
                          LogoWidget(animation: _formAnimation),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          WelcomeTextWidget(
                            title: 'Create Account',
                            subtitle: 'Join Emosense and start your journey',
                            animation: _formAnimation,
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 25),
                          // Prominent role selection section
                          RoleSelectionWidget(
                            selectedRole: _selectedRole,
                            onRoleChanged: (role) {
                              setState(() {
                                _selectedRole = role;
                              });
                            },
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
                          SizedBox(height: isSmallScreen ? 20 : 25),
                          // Main form without role selection
                          _buildMainForm(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          AuthButtonWidget(
                            text: 'Create Account',
                            onPressed: _handleSignUp,
                            isLoading: _isLoading,
                            animation: _formAnimation,
                          ),
                          SizedBox(height: isSmallScreen ? 10 : 15),
                          TermsAndConditionsWidget(
                            agreeToTerms: _agreeToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreeToTerms = value;
                              });
                            },
                            animation: _formAnimation,
                          ),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          DividerWidget(animation: _formAnimation),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          SocialLoginWidget(
                            animation: _formAnimation,
                            buttons: [
                              SocialLoginButton(
                                text: 'Google',
                                icon: Icons.g_mobiledata,
                                textColor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  // TODO: Implement Google sign-up
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Google sign-up coming soon!',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              SocialLoginButton(
                                text: 'Apple',
                                icon: Icons.apple,
                                textColor: Colors.white,
                                backgroundColor: Colors.black,
                                onPressed: () {
                                  // TODO: Implement Apple sign-up
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Apple sign-up coming soon!',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                              SocialLoginButton(
                                text: 'Microsoft',
                                icon: Icons.window,
                                textColor: Colors.white,
                                backgroundColor: const Color(0xFF0078D4),
                                onPressed: () {
                                  // TODO: Implement Microsoft sign-up
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Microsoft sign-up coming soon!',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          AuthLinkWidget(
                            leadingText: 'Already have an account?',
                            linkText: 'Sign In',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRouter.login,
                              );
                            },
                            animation: _formAnimation,
                          ),
                          SizedBox(height: isSmallScreen ? 30 : 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainForm() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AuthTextFieldWidget(
                            controller: _firstNameController,
                            label: 'First Name',
                            hintText: 'Enter your first name',
                            prefixIcon: Icons.person_outline,
                            useWhiteBackground: true,
                            animation: _formAnimation,
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
                            controller: _lastNameController,
                            label: 'Last Name',
                            hintText: 'Enter your last name',
                            prefixIcon: Icons.person_outline,
                            useWhiteBackground: true,
                            animation: _formAnimation,
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
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      useWhiteBackground: true,
                      animation: _formAnimation,
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
                    if (_selectedRole == 'Employee') ...[
                      const SizedBox(height: 16),
                      AuthTextFieldWidget(
                        controller: _employeeIdController,
                        label: 'Employee ID',
                        hintText: 'Enter your employee ID',
                        prefixIcon: Icons.badge_outlined,
                        useWhiteBackground: true,
                        animation: _formAnimation,
                        validator: (value) {
                          if (_selectedRole == 'Employee' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Employee ID is required';
                          }
                          if (_selectedRole == 'Employee' &&
                              value!.trim().length < 3) {
                            return 'Employee ID must be at least 3 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AuthTextFieldWidget(
                        controller: _departmentController,
                        label: 'Department',
                        hintText: 'Enter your department',
                        prefixIcon: Icons.business_outlined,
                        useWhiteBackground: true,
                        animation: _formAnimation,
                        validator: (value) {
                          if (_selectedRole == 'Employee' &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Department is required';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    AuthTextFieldWidget(
                      controller: _passwordController,
                      label: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      useWhiteBackground: true,
                      animation: _formAnimation,
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
                      controller: _confirmPasswordController,
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                      prefixIcon: Icons.lock_outline,
                      isPasswordField: true,
                      isPasswordVisible: _isConfirmPasswordVisible,
                      onPasswordToggle: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      useWhiteBackground: true,
                      animation: _formAnimation,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
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
