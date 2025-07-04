import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../employee/employee_navigation_screen.dart';
import '../admin/admin_navigation_screen.dart';
import '../../../core/routing/app_router.dart';

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
          children: [_buildAnimatedBackground(), _buildLoginContent()],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF667EEA),
                const Color(0xFF764BA2),
                const Color(0xFF48CAE4),
                const Color(0xFF667EEA),
              ],
              stops: [
                0.0 + (0.1 * _backgroundAnimation.value),
                0.3 + (0.1 * _backgroundAnimation.value),
                0.7 + (0.1 * _backgroundAnimation.value),
                1.0,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Floating animated circles
              _buildFloatingCircle(
                top: 100 + (20 * _backgroundAnimation.value),
                right: 50 + (30 * _backgroundAnimation.value),
                size: 80,
                opacity: 0.1,
              ),
              _buildFloatingCircle(
                bottom: 200 + (40 * _backgroundAnimation.value),
                left: 30 + (20 * _backgroundAnimation.value),
                size: 120,
                opacity: 0.08,
              ),
              _buildFloatingCircle(
                top: 300 + (15 * _backgroundAnimation.value),
                left: 200 + (25 * _backgroundAnimation.value),
                size: 60,
                opacity: 0.12,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: opacity),
          shape: BoxShape.circle,
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
                    _buildLogo(),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    _buildWelcomeText(),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    _buildLoginForm(),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    _buildLoginButton(),
                    SizedBox(height: isSmallScreen ? 10 : 15),
                    _buildRememberMeAndForgotPassword(),
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    _buildDivider(),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    _buildSocialLoginButtons(),
                    SizedBox(height: isSmallScreen ? 20 : 25),
                    _buildSignUpLink(),
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

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoAnimation.value,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF8F9FA)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_emotions,
              size: 50,
              color: Color(0xFF667EEA),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Column(
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your role and sign in to access GraphSmile',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginForm() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildRoleSelection(),
                    const SizedBox(height: 20),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleSelection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12, bottom: 8),
            child: Text(
              'Sign in as',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildRoleOption(
                  'Employee',
                  Icons.person_outline,
                  'Access employee dashboard',
                  const Color(0xFF667EEA),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRoleOption(
                  'Admin',
                  Icons.admin_panel_settings_outlined,
                  'Access admin panel',
                  const Color(0xFF764BA2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRoleOption(
    String role,
    IconData icon,
    String description,
    Color color,
  ) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color.withValues(alpha: 0.8), color])
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              role,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outlined),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
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
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _selectedRole == 'Admin'
                          ? [const Color(0xFF764BA2), const Color(0xFF667EEA)]
                          : [const Color(0xFF667EEA), const Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _selectedRole == 'Admin'
                                    ? Icons.admin_panel_settings
                                    : Icons.person,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Sign in as $_selectedRole',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: const Color(0xFF667EEA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      'Remember me',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
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

  Widget _buildDivider() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _formAnimation.value,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialLoginButtons() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _formAnimation.value,
          child: Row(
            children: [
              Expanded(
                child: _buildSocialButton(
                  'Google',
                  Icons.g_mobiledata,
                  Colors.white,
                  const Color(0xFFDB4437),
                  () => _handleSocialLogin('google'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialButton(
                  'Microsoft',
                  Icons.business,
                  Colors.white,
                  const Color(0xFF00A4EF),
                  () => _handleSocialLogin('microsoft'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialButton(
    String text,
    IconData icon,
    Color textColor,
    Color backgroundColor,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor, size: 20),
        label: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _formAnimation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: _navigateToSignUp,
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
