import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/onboarding/onboarding.dart';
import '../../widgets/common/animated_background_widget.dart';
import '../../services/onboarding_preferences.dart';
import '../../models/onboarding_models.dart';

/// Onboarding Screen with feature showcase and modern UI
///
/// Features:
/// - Multi-page feature introduction
/// - Smooth page transitions
/// - Modern card-based design
/// - Interactive elements
/// - Skip functionality
/// - Persistent completion tracking
/// - Animated background effects
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;

  int _currentPage = 0;
  final int _totalPages = 4;

  // Define onboarding pages data
  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to EmoSense',
      description:
          'Unlock the power of emotional intelligence with cutting-edge AI. Transform how you understand and respond to emotions in text, making every interaction more meaningful.',
      icon: Icons.psychology_outlined,
      primaryColor: Color(0xFFFFFFFF), // White for better visibility
      secondaryColor: Color(0xFFF0F4FF), // Light blue-white
    ),
    OnboardingPageData(
      title: 'Enhanced Text Analysis',
      description:
          'Experience next-level text analysis that goes beyond words. Our AI detects subtle emotional cues, sentiment patterns, and psychological insights with unprecedented accuracy.',
      icon: Icons.text_fields,
      primaryColor: Color(0xFFFFFFFF), // White for better visibility
      secondaryColor: Color(0xFFF0F8FF), // Alice blue
    ),
    OnboardingPageData(
      title: 'Employee Analytics',
      description:
          'Empower your team with data-driven emotional intelligence. Track wellbeing, identify stress patterns, and create a healthier, more productive workplace environment.',
      icon: Icons.group,
      primaryColor: Color(0xFFFFFFFF), // White for better visibility
      secondaryColor: Color(0xFFF5F8FF), // Very light lavender
    ),
    OnboardingPageData(
      title: 'Get Started',
      description:
          'Ready to revolutionize your communication? Join thousands who\'ve already discovered the transformative power of emotional intelligence in their daily interactions.',
      icon: Icons.rocket_launch,
      primaryColor: Color(0xFFFFFFFF), // White for better visibility
      secondaryColor: Color(0xFFF8FAFF), // Very light blue
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startEntryAnimation();
  }

  void _initializeControllers() {
    _pageController = PageController();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    // Start background animation loop
    _backgroundController.repeat();
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  void _nextPage() {
    HapticFeedback.lightImpact();
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    HapticFeedback.lightImpact();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.mediumImpact();
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Save onboarding completion with persistent storage
    final success = await OnboardingPreferences.setOnboardingCompleted();

    if (success) {
      // Show success feedback
      HapticFeedback.mediumImpact();
    }

    // Navigate to auth choice screen
    if (mounted) {
      AppRouter.toAuthChoice(context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Stack(
              children: [
                // Animated background
                AnimatedBackgroundWidget(animation: _backgroundAnimation),

                // Main content
                SafeArea(
                  child: OnboardingContent(
                    pageController: _pageController,
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    pages: _pages,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                      HapticFeedback.selectionClick();
                    },
                    onNext: _nextPage,
                    onPrevious: _previousPage,
                    onSkip: _skipOnboarding,
                    onGetStarted: _completeOnboarding,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
