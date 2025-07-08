import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// A comprehensive onboarding screen with step-by-step progress
class OnboardingWizard extends StatefulWidget {
  final List<OnboardingStep> steps;
  final VoidCallback onComplete;
  final VoidCallback? onSkip;
  final String completeButtonText;
  final String skipButtonText;
  final String nextButtonText;
  final String backButtonText;
  final bool showProgress;
  final Color? progressColor;

  const OnboardingWizard({
    super.key,
    required this.steps,
    required this.onComplete,
    this.onSkip,
    this.completeButtonText = 'Get Started',
    this.skipButtonText = 'Skip',
    this.nextButtonText = 'Next',
    this.backButtonText = 'Back',
    this.showProgress = true,
    this.progressColor,
  });

  @override
  State<OnboardingWizard> createState() => _OnboardingWizardState();
}

class _OnboardingWizardState extends State<OnboardingWizard>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentStep = 0;
  bool _isLastStep = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    _updateLastStep();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateLastStep() {
    _isLastStep = _currentStep == widget.steps.length - 1;
  }

  void _nextStep() {
    if (_isLastStep) {
      widget.onComplete();
    } else {
      _animationController.reset();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.forward();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _animationController.reset();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.forward();
    }
  }

  void _skipOnboarding() {
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress and skip button
            _buildHeader(),
            
            // Main content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                    _updateLastStep();
                  });
                  HapticFeedback.selectionClick();
                },
                itemCount: widget.steps.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildStepContent(widget.steps[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            
            // Bottom navigation
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Progress indicator
          if (widget.showProgress) ...[
            Expanded(
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / widget.steps.length,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.progressColor ?? AppColors.primary,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // Skip button
          if (widget.onSkip != null || !_isLastStep) ...[
            TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                widget.skipButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepContent(OnboardingStep step) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration or icon
          if (step.illustration != null) ...[
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.surfaceContainer,
              ),
              child: step.illustration,
            ),
          ] else if (step.icon != null) ...[
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    step.primaryColor ?? AppColors.primary,
                    step.secondaryColor ?? AppColors.accent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (step.primaryColor ?? AppColors.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                step.icon,
                size: 60,
                color: Colors.white,
              ),
            ),
          ],
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            step.description,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          // Additional content
          if (step.content != null) ...[
            const SizedBox(height: 24),
            step.content!,
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Text(widget.backButtonText),
              ),
            ),
            const SizedBox(width: 16),
          ],
          
          // Next/Complete button
          Expanded(
            flex: _currentStep > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isLastStep ? widget.completeButtonText : widget.nextButtonText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model class for onboarding steps
class OnboardingStep {
  final String title;
  final String description;
  final IconData? icon;
  final Widget? illustration;
  final Widget? content;
  final Color? primaryColor;
  final Color? secondaryColor;

  const OnboardingStep({
    required this.title,
    required this.description,
    this.icon,
    this.illustration,
    this.content,
    this.primaryColor,
    this.secondaryColor,
  });
}
