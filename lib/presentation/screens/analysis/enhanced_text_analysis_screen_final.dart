import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../widgets/analysis/analysis.dart';
import '../../cubit/text_analysis/text_analysis_cubit.dart';

/// Enhanced Text Analysis Screen
///
/// This screen provides comprehensive text analysis capabilities including:
/// - Sentiment Analysis
/// - Emotion Detection
/// - Topic Classification
/// - Intent Recognition
/// - Language Detection
///
/// Features:
/// - Real-time analysis with immediate feedback
/// - Multiple analysis types with easy switching
/// - Rich result visualization with charts and insights
/// - Analysis history tracking and management
/// - Export and sharing capabilities
/// - Responsive design for mobile and tablet
///
/// The screen has been completely refactored into modular widgets:
/// - EnhancedTextAnalysisAppBar: Clean app bar with info button
/// - EnhancedTextAnalysisContentWidget: Main content with animations
/// - TextAnalysisMainContentWidget: Scrollable content sections
/// - EnhancedTextAnalysisHeaderWidget: Header with stats
/// - TextAnalysisConstants: Centralized constants and sample data
class EnhancedTextAnalysisScreen extends StatelessWidget {
  const EnhancedTextAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TextAnalysisCubit(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const EnhancedTextAnalysisAppBar(),
        body: const EnhancedTextAnalysisContentWidget(),
      ),
    );
  }
}
