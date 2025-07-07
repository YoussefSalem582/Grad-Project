import 'package:flutter/material.dart';

/// Bottom navigation widget for onboarding with skip, next, and previous buttons
class OnboardingBottomNavigation extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final VoidCallback? onGetStarted;
  final bool showSkip;
  final bool showPrevious;
  final String nextText;
  final String skipText;
  final String getStartedText;
  final String previousText;

  const OnboardingBottomNavigation({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.onSkip,
    this.onNext,
    this.onPrevious,
    this.onGetStarted,
    this.showSkip = true,
    this.showPrevious = true,
    this.nextText = 'Next',
    this.skipText = 'Skip',
    this.getStartedText = 'Get Started',
    this.previousText = 'Previous',
  }) : super(key: key);

  @override
  State<OnboardingBottomNavigation> createState() =>
      _OnboardingBottomNavigationState();
}

class _OnboardingBottomNavigationState extends State<OnboardingBottomNavigation>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool get isLastPage => widget.currentPage == widget.totalPages - 1;
  bool get isFirstPage => widget.currentPage == 0;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip/Previous button
              _buildLeftButton(),

              // Next/Get Started button
              _buildRightButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftButton() {
    if (isFirstPage) {
      // Show Skip button on first page
      return widget.showSkip
          ? _buildTextButton(
            text: widget.skipText,
            onPressed: widget.onSkip,
            isSecondary: true,
          )
          : const SizedBox(width: 80);
    } else {
      // Show Previous button on other pages
      return widget.showPrevious
          ? _buildTextButton(
            text: widget.previousText,
            onPressed: widget.onPrevious,
            isSecondary: true,
            icon: Icons.arrow_back_ios,
          )
          : const SizedBox(width: 80);
    }
  }

  Widget _buildRightButton() {
    if (isLastPage) {
      // Show Get Started button on last page
      return _buildElevatedButton(
        text: widget.getStartedText,
        onPressed: widget.onGetStarted,
        icon: Icons.arrow_forward,
      );
    } else {
      // Show Next button on other pages
      return _buildElevatedButton(
        text: widget.nextText,
        onPressed: widget.onNext,
        icon: Icons.arrow_forward_ios,
      );
    }
  }

  Widget _buildTextButton({
    required String text,
    VoidCallback? onPressed,
    bool isSecondary = false,
    IconData? icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white.withValues(alpha: 0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && text == widget.previousText) ...[
              Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    isSecondary
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatedButton({
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

/// Floating action button style navigation for onboarding
class OnboardingFloatingNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onNext;
  final VoidCallback? onGetStarted;
  final Color backgroundColor;
  final Color iconColor;

  const OnboardingFloatingNavigation({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.onNext,
    this.onGetStarted,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
  }) : super(key: key);

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: isLastPage ? onGetStarted : onNext,
      backgroundColor: backgroundColor,
      elevation: 6,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isLastPage ? Icons.check : Icons.arrow_forward,
          key: ValueKey(isLastPage),
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }
}
