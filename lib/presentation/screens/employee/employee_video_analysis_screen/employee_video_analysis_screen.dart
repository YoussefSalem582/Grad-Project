import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../cubit/video_analysis/video_analysis_cubit.dart';
import 'widgets/widgets.dart';

/// Refactored Employee Video Analysis Screen with modular components
///
/// This screen has been broken down into reusable components:
/// - VideoAnalysisHeader: Animated header with branding
/// - VideoUrlInput: URL input with validation and focus states
/// - AnalyzeButton: Dynamic button with loading states
/// - VideoAnalysisResults: Comprehensive results display
/// - EmployeeInsights: Actionable insights and recommendations
class EmployeeVideoAnalysisScreen extends StatefulWidget {
  const EmployeeVideoAnalysisScreen({super.key});

  @override
  State<EmployeeVideoAnalysisScreen> createState() =>
      _EmployeeVideoAnalysisScreenState();
}

class _EmployeeVideoAnalysisScreenState
    extends State<EmployeeVideoAnalysisScreen>
    with TickerProviderStateMixin {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();

  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _resultsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _urlFocusNode.addListener(_onFocusChanged);
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _resultsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _cardController.forward();
    });
  }

  void _onFocusChanged() {
    if (_urlFocusNode.hasFocus) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    _headerController.dispose();
    _cardController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Video Analysis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Header
              VideoAnalysisHeader(animation: _headerAnimation),

              const SizedBox(height: 24),

              // Video URL Input
              VideoUrlInput(
                controller: _urlController,
                focusNode: _urlFocusNode,
                animation: _cardAnimation,
                onChanged: () => setState(() {}),
              ),

              const SizedBox(height: 20),

              // Analyze Button
              AnalyzeButton(
                animation: _cardAnimation,
                canAnalyze: _urlController.text.isNotEmpty,
                onPressed: _analyzeVideo,
              ),

              const SizedBox(height: 24),

              // Video Analysis Results
              VideoAnalysisResults(resultsController: _resultsController),

              const SizedBox(height: 20),

              // Employee Insights
              const EmployeeInsights(),
            ],
          ),
        ),
      ),
    );
  }

  /// Analyze video using the cubit
  void _analyzeVideo() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty) {
      context.read<VideoAnalysisCubit>().analyzeVideo(videoUrl: url);
      HapticFeedback.mediumImpact();
    }
  }
}
