import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/routing/app_router.dart';
import 'widgets/auth_choice.dart';

/// Authentication choice screen where users can choose between Login and Sign Up
///
/// Features:
/// - Modern card-based design
/// - Smooth animations and transitions
/// - Clear call-to-action buttons
/// - Consistent branding with app theme
/// - Haptic feedback for interactions
/// - Modular widget structure
class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardController;
  late AnimationController _backgroundController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    // Start background animation loop
    _backgroundController.repeat();
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _cardController.forward();
    });
  }

  void _navigateToLogin() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRouter.login);
  }

  void _navigateToSignUp() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRouter.signup);
  }

  void _navigateBack() {
    HapticFeedback.lightImpact();
    AppRouter.toOnboarding(context);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthChoiceContent(
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        cardScaleAnimation: _cardScaleAnimation,
        backgroundAnimation: _backgroundAnimation,
        onLoginPressed: _navigateToLogin,
        onSignUpPressed: _navigateToSignUp,
        onBackPressed: _navigateBack,
      ),
    );
  }
}
