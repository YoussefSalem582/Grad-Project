import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/routing/app_router.dart';
import '../../widgets/common/animated_background_widget.dart';

/// Authentication choice screen where users can choose between Login and Sign Up
///
/// Features:
/// - Modern card-based design
/// - Smooth animations and transitions
/// - Clear call-to-action buttons
/// - Consistent branding with app theme
/// - Haptic feedback for interactions
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

  void _navigateBackToOnboarding() {
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
      body: Stack(
        children: [
          // Animated background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Back button
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      onPressed: _navigateBackToOnboarding,
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // App branding
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.1,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      'assets/images/app_icon.png',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 24),

                                // Welcome text
                                Text(
                                  'Welcome to EmoSense',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  'Choose how you\'d like to continue',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 60),

                                // Action cards
                                AnimatedBuilder(
                                  animation: _cardController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _cardScaleAnimation.value,
                                      child: Column(
                                        children: [
                                          // Login card
                                          _buildActionCard(
                                            title: 'Sign In',
                                            subtitle:
                                                'Already have an account?',
                                            description:
                                                'Welcome back! Sign in to access your emotional analytics dashboard.',
                                            icon: Icons.login,
                                            primaryColor: Colors.blue.shade600,
                                            onTap: _navigateToLogin,
                                            isElevated: true,
                                          ),

                                          const SizedBox(height: 20),

                                          // Sign up card
                                          _buildActionCard(
                                            title: 'Sign Up',
                                            subtitle: 'New to EmoSense?',
                                            description:
                                                'Create your account and start analyzing emotions with AI.',
                                            icon: Icons.person_add,
                                            primaryColor:
                                                Colors.purple.shade600,
                                            onTap: _navigateToSignUp,
                                            isElevated: false,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Footer
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value * 0.7,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          children: [
                            Text(
                              'By continuing, you agree to our Terms of Service',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'and Privacy Policy',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
    required bool isElevated,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color:
              isElevated ? primaryColor : Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border:
              isElevated
                  ? null
                  : Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
          boxShadow: [
            BoxShadow(
              color: (isElevated ? primaryColor : Colors.black).withValues(
                alpha: isElevated ? 0.3 : 0.2,
              ),
              blurRadius: isElevated ? 20 : 15,
              offset: Offset(0, isElevated ? 10 : 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color:
                    isElevated
                        ? Colors.white.withValues(alpha: 0.2)
                        : primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: isElevated ? Colors.white : primaryColor,
                size: 30,
              ),
            ),

            const SizedBox(width: 20),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isElevated ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isElevated
                              ? Colors.white.withValues(alpha: 0.9)
                              : primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          isElevated
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              color:
                  isElevated
                      ? Colors.white.withValues(alpha: 0.7)
                      : primaryColor.withValues(alpha: 0.7),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
