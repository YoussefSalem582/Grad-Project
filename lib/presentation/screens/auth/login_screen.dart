import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../employee/employee_navigation_screen.dart';
import '../admin/admin_navigation_screen.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/auth/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String _selectedRole = 'Employee'; // Default role

  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _backgroundController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );
    _formAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _formController.forward();
    });
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _backgroundController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
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
            _buildLoginContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginContent() {
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 24.0,
                ),
                child: Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 30 : 40),
                    LogoWidget(animation: _logoAnimation),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    WelcomeTextWidget(
                      animation: _formAnimation,
                      title: 'Welcome Back!',
                      subtitle:
                          'Choose your role and sign in to access Emosense',
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    _buildLoginForm(),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    AuthButtonWidget(
                      animation: _formAnimation,
                      onPressed: _handleLogin,
                      text: 'Sign in as $_selectedRole',
                      isLoading: _isLoading,
                      icon: _selectedRole == 'Admin'
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      gradientColors: _selectedRole == 'Admin'
                          ? [const Color(0xFF764BA2), const Color(0xFF667EEA)]
                          : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                    ),
                    SizedBox(height: isSmallScreen ? 10 : 15),
                    RememberMeWidget(
                      animation: _formAnimation,
                      value: _rememberMe,
                      onChanged: (value) => setState(() => _rememberMe = value),
                      onForgotPassword: _showForgotPasswordDialog,
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    DividerWidget(animation: _formAnimation),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    SocialLoginWidget(
                      animation: _formAnimation,
                      buttons: [
                        SocialLoginButton(
                          text: 'Google',
                          icon: Icons.g_mobiledata,
                          textColor: Colors.white,
                          backgroundColor: const Color(0xFFDB4437),
                          onPressed: () => _handleSocialLogin('google'),
                        ),
                        SocialLoginButton(
                          text: 'Microsoft',
                          icon: Icons.business,
                          textColor: Colors.white,
                          backgroundColor: const Color(0xFF00A4EF),
                          onPressed: () => _handleSocialLogin('microsoft'),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    AuthLinkWidget(
                      animation: _formAnimation,
                      leadingText: "Don't have an account? ",
                      linkText: 'Sign Up',
                      onPressed: _navigateToSignUp,
                    ),
                    SizedBox(height: isSmallScreen ? 30 : 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm() {
    return AuthFormWidget(
      animation: _formAnimation,
      formKey: _formKey,
      child: Column(
        children: [
          RoleSelectionWidget(
            selectedRole: _selectedRole,
            onRoleChanged: (role) => setState(() => _selectedRole = role),
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
            controller: _emailController,
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
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outlined,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
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

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Add haptic feedback
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // For demo purposes, accept any valid email/password
    // In a real app, you would validate credentials with your backend
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // Navigate based on selected role
      Widget targetScreen;
      if (_selectedRole == 'Admin') {
        targetScreen = const AdminNavigationScreen();
      } else {
        targetScreen = const EmployeeNavigationScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    } else {
      // Show error
      _showErrorDialog('Invalid credentials. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleSocialLogin(String provider) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    // Simulate social login
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Navigate based on selected role
      Widget targetScreen;
      if (_selectedRole == 'Admin') {
        targetScreen = const AdminNavigationScreen();
      } else {
        targetScreen = const EmployeeNavigationScreen();
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    });
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address to receive a password reset link.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog('Password reset link sent to your email!');
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, AppRouter.signup);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Login Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
