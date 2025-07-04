import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [_buildAnimatedBackground(), _buildScrollableContent()],
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
                          _buildHeader(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          _buildWelcomeText(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          _buildSignUpForm(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          _buildSignUpButton(),
                          SizedBox(height: isSmallScreen ? 10 : 15),
                          _buildTermsSection(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          _buildDivider(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          _buildSocialSignUpButtons(),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          _buildLoginLink(),
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
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacity),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _formAnimation.value)),
          child: Opacity(
            opacity: _formAnimation.value,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.white, Color(0xFFF8F9FA)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 30,
                    color: Color(0xFF667EEA),
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 48), // Balance the back button
              ],
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
                  'Create Account',
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
                  'Join GraphSmile and start your journey with us',
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

  Widget _buildSignUpForm() {
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
                key: _formKey,
                child: Column(
                  children: [
                    _buildRoleSelector(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildFirstNameField()),
                        const SizedBox(width: 12),
                        Expanded(child: _buildLastNameField()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                    if (_selectedRole == 'Employee') ...[
                      const SizedBox(height: 16),
                      _buildEmployeeIdField(),
                      const SizedBox(height: 16),
                      _buildDepartmentField(),
                    ],
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildConfirmPasswordField(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Type',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: _buildRoleOption('Employee', Icons.badge)),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildRoleOption('Admin', Icons.admin_panel_settings),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleOption(String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _firstNameController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'First Name',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your first name';
        }
        if (value.length < 2) {
          return 'First name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _lastNameController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Last Name',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your last name';
        }
        if (value.length < 2) {
          return 'Last name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildEmployeeIdField() {
    return TextFormField(
      controller: _employeeIdController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Employee ID',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.badge,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (_selectedRole == 'Employee' && (value == null || value.isEmpty)) {
          return 'Please enter your employee ID';
        }
        return null;
      },
    );
  }

  Widget _buildDepartmentField() {
    return TextFormField(
      controller: _departmentController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Department',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.business,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (_selectedRole == 'Employee' && (value == null || value.isEmpty)) {
          return 'Please enter your department';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 characters';
        }
        if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
          return 'Password must contain uppercase, lowercase, and number';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.white.withValues(alpha: 0.8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.white.withValues(alpha: 0.8),
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _formAnimation.value,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF667EEA),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF667EEA),
                        ),
                      ),
                    )
                  : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _formAnimation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Sign In',
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

  Widget _buildTermsSection() {
    return AnimatedBuilder(
      animation: _formAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _formAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: _agreeToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreeToTerms = value ?? false;
                    });
                  },
                  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return Colors.transparent;
                  }),
                  checkColor: const Color(0xFF667EEA),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 2,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreeToTerms = !_agreeToTerms;
                      });
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildSocialSignUpButtons() {
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
                  () => _handleSocialSignUp('google'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSocialButton(
                  'Microsoft',
                  Icons.business,
                  Colors.white,
                  const Color(0xFF00A4EF),
                  () => _handleSocialSignUp('microsoft'),
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
      height: 48,
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

  void _handleSocialSignUp(String provider) {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),
    );

    // Simulate social signup
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      _showSuccessDialog();
    });
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreeToTerms) {
      _showErrorDialog(
        'Please agree to the Terms of Service and Privacy Policy',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically:
      // 1. Create user account via API
      // 2. Send verification email
      // 3. Store user data
      // 4. Navigate to appropriate screen

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog('Failed to create account. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Sign Up Failed'),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Account Created'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your account has been created successfully!'),
            const SizedBox(height: 16),
            Text(
              'Account Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Name: ${_firstNameController.text} ${_lastNameController.text}',
            ),
            Text('• Email: ${_emailController.text}'),
            Text('• Role: $_selectedRole'),
            if (_selectedRole == 'Employee' &&
                _employeeIdController.text.isNotEmpty)
              Text('• Employee ID: ${_employeeIdController.text}'),
            if (_selectedRole == 'Employee' &&
                _departmentController.text.isNotEmpty)
              Text('• Department: ${_departmentController.text}'),
            const SizedBox(height: 16),
            Text(
              'A verification email has been sent to ${_emailController.text}. Please check your inbox and verify your email before signing in.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to login screen
            },
            child: const Text('Go to Sign In'),
          ),
        ],
      ),
    );
  }
}
