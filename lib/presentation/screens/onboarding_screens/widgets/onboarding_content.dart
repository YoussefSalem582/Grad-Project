import 'package:flutter/material.dart';
import 'onboarding.dart';
import '../../../models/onboarding_models.dart';

/// Main content widget for the onboarding screen
///
/// This widget contains the page view and navigation controls
class OnboardingContent extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final List<OnboardingPageData> pages;
  final Function(int) onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;
  final VoidCallback onGetStarted;

  const OnboardingContent({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.pages,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with app icon
        const OnboardingAppHeader(),

        // Page content
        Expanded(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: totalPages,
            itemBuilder: (context, index) {
              final page = pages[index];
              return OnboardingPage(
                title: page.title,
                description: page.description,
                icon: page.icon,
                primaryColor: page.primaryColor,
                secondaryColor: page.secondaryColor,
                isVisible: index == currentPage,
              );
            },
          ),
        ),

        // Page indicator
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: OnboardingPageIndicator(
            currentPage: currentPage,
            totalPages: totalPages,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withValues(alpha: 0.4),
          ),
        ),

        // Bottom navigation
        OnboardingBottomNavigation(
          currentPage: currentPage,
          totalPages: totalPages,
          onNext: onNext,
          onPrevious: onPrevious,
          onSkip: onSkip,
          onGetStarted: onGetStarted,
        ),
      ],
    );
  }
}
