import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../cubit/video_analysis/video_analysis_cubit.dart';
import '../../../widgets/common/animated_background_widget.dart';
import '../../../widgets/common/animated_loading_indicator.dart';
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
  File? _selectedVideoFile;

  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _resultsController;
  late AnimationController _backgroundController;
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _backgroundAnimation;

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

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutBack),
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );

    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _cardController.forward();
    });
    _backgroundController.repeat(reverse: true);
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
    _backgroundController.dispose();
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
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated Header
                  VideoAnalysisHeader(animation: _headerAnimation),

                  const SizedBox(height: 24),

                  // Video Input (URL or File)
                  VideoInputWidget(
                    urlController: _urlController,
                    urlFocusNode: _urlFocusNode,
                    animation: _cardAnimation,
                    onChanged: () => setState(() {}),
                    onFileSelected:
                        (file) => setState(
                          () =>
                              _selectedVideoFile =
                                  file.path.isEmpty ? null : file,
                        ),
                    selectedFile: _selectedVideoFile,
                  ),

                  const SizedBox(height: 16),

                  // Sample Video Links
                  VideoSampleLinksWidget(
                    urlController: _urlController,
                    animation: _cardAnimation,
                    onSampleSelected: () => setState(() {}),
                  ),

                  const SizedBox(height: 20),

                  // Analyze Button
                  AnalyzeButton(
                    animation: _cardAnimation,
                    canAnalyze:
                        _urlController.text.isNotEmpty ||
                        _selectedVideoFile != null,
                    onPressed: _analyzeVideo,
                  ),

                  const SizedBox(height: 24),

                  // Video Analysis Results with EMO Loading
                  BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
                    builder: (context, state) {
                      print('Current VideoAnalysisState: $state');

                      if (state is VideoAnalysisLoading) {
                        return Container(
                          padding: const EdgeInsets.all(40),

                          child: Column(
                            children: [
                              EmoLoader.analysis(),
                              const SizedBox(height: 20),
                              const Text(
                                'Analyzing video content...',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Processing visual cues and emotional patterns',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  '⏱️ Processing may take 3-6 seconds',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (state is VideoAnalysisError) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Analysis Failed',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                state.message,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return VideoAnalysisResults(
                          resultsController: _resultsController,
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  // Employee Insights
                  const EmployeeInsights(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Analyze video using the cubit
  void _analyzeVideo() {
    try {
      if (_selectedVideoFile != null) {
        // Analyze uploaded video file
        print('Analyzing video file: ${_selectedVideoFile!.path}');
        context.read<VideoAnalysisCubit>().analyzeVideoFile(
          videoFile: _selectedVideoFile!,
        );
      } else {
        // Analyze video from URL
        final url = _urlController.text.trim();
        if (url.isNotEmpty) {
          print('Analyzing video URL: $url');
          context.read<VideoAnalysisCubit>().analyzeVideo(videoUrl: url);
        } else {
          // Show error if no input provided
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please provide a video URL or select a video file',
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
      HapticFeedback.mediumImpact();
    } catch (e) {
      print('Error starting video analysis: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting analysis: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
