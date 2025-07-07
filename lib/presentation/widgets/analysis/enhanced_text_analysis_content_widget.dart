import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../cubit/text_analysis/text_analysis_cubit.dart';
import '../common/animated_background_widget.dart';
import 'text_analysis_constants.dart';
import 'text_analysis_main_content_widget.dart';

/// Main content wrapper for the Enhanced Text Analysis screen
///
/// Manages the overall layout including the animated background,
/// fade transitions, and scrollable content sections.
class EnhancedTextAnalysisContentWidget extends StatefulWidget {
  const EnhancedTextAnalysisContentWidget({super.key});

  @override
  State<EnhancedTextAnalysisContentWidget> createState() =>
      _EnhancedTextAnalysisContentWidgetState();
}

class _EnhancedTextAnalysisContentWidgetState
    extends State<EnhancedTextAnalysisContentWidget>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: TextAnalysisConstants.backgroundAnimationDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: TextAnalysisConstants.fadeAnimationDuration,
      vsync: this,
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TextAnalysisCubit, TextAnalysisState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        return Stack(
          children: [
            // Animated Background
            AnimatedBackgroundWidget(animation: _backgroundAnimation),

            // Main Content with Fade Animation
            FadeTransition(
              opacity: _fadeAnimation,
              child: SafeArea(
                child: TextAnalysisMainContentWidget(state: state),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Handle state changes from the cubit with improved feedback
  void _handleStateChanges(BuildContext context, TextAnalysisState state) {
    if (state is TextAnalysisSuccess) {
      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Text analysis completed successfully!'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (state is TextAnalysisError) {
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(state.message)),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              // Retry action could be implemented here
            },
          ),
        ),
      );
    } else if (state is TextAnalysisLoading) {
      HapticFeedback.selectionClick();
    }
  }
}
