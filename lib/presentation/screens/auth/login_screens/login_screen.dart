import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../employee/employee_navigation_screen/employee_navigation_screen.dart';
import '../../admin/admin_navigation_screen.dart';
import '../../../widgets/auth/auth.dart';
import 'widgets/login.dart';

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
                    LoginHeader(
                      logoAnimation: _logoAnimation,
                      formAnimation: _formAnimation,
                    ),
                    LoginForm(
                      formAnimation: _formAnimation,
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      selectedRole: _selectedRole,
                      onRoleChanged:
                          (role) => setState(() => _selectedRole = role),
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    LoginFooter(
                      formAnimation: _formAnimation,
                      selectedRole: _selectedRole,
                      onLogin: _handleLogin,
                      isLoading: _isLoading,
                      rememberMe: _rememberMe,
                      onRememberMeChanged:
                          (value) => setState(() => _rememberMe = value),
                      onForgotPassword: _showForgotPasswordDialog,
                      onSocialLogin: _handleSocialLogin,
                      onNavigateToSignUp: _navigateToSignUp,
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

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      }
    } else {
      // Show error
      _showErrorDialog('Invalid credentials. Please try again.');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleSocialLogin(String provider) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
    );

    // Simulate social login
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
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
      }
    });
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Forgot Password'),
            content: const Text(
              'Password reset functionality will be available soon. Please contact your administrator.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }
}
