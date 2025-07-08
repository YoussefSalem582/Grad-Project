import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/core.dart';
import '../../../core/routing/app_router.dart';
import '../../services/onboarding_preferences.dart';
import 'widgets/splash.dart';

/// Enhanced Splash Screen with modern animations and branding
///
/// Features:
/// - Smooth gradient animations
/// - Logo scale and rotation effects
/// - Particle effects simulation
/// - Modern UI design
/// - Brand identity consistency
/// - Modular widget structure
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Logo animations - Enhanced with better curves
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Text animations - Smoother timing
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Background animations - Longer duration for smoother effect
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Particle animations - More natural movement
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    // Logo animations with enhanced curves
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Text animations with staggered timing
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Background animation with smoother progression
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutSine,
      ),
    );

    // Particle animation with natural movement
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particleController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _startSplashSequence() async {
    // Start animations in sequence with better timing
    _backgroundController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _particleController.forward();

    // Wait for animations to complete and allow user to see the splash
    await Future.delayed(const Duration(milliseconds: 1800));

    // Navigate to next screen
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    try {
      // Check if onboarding is completed
      final bool isOnboardingCompleted =
          await OnboardingPreferences.isOnboardingCompleted();

      if (!mounted) return;

      if (isOnboardingCompleted) {
        // Navigate to auth choice screen
        AppRouter.toAuthChoice(context);
      } else {
        // Navigate to onboarding screen
        AppRouter.toOnboarding(context);
      }
    } catch (e) {
      // Fallback navigation
      if (mounted) {
        AppRouter.toOnboarding(context);
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashContent(
        logoScaleAnimation: _logoScaleAnimation,
        logoRotationAnimation: _logoRotationAnimation,
        textFadeAnimation: _textFadeAnimation,
        textSlideAnimation: _textSlideAnimation,
        backgroundAnimation: _backgroundAnimation,
        particleAnimation: _particleAnimation,
      ),
    );
  }
}
