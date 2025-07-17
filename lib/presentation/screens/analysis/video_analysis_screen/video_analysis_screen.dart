import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../cubit/video_analysis/video_analysis_cubit.dart';
import '../../../widgets/common/animated_background_widget.dart';
import '../../../widgets/common/animated_loading_indicator.dart';
import '../../../widgets/app_bars/analysis_app_bar.dart';
import 'widgets/widgets.dart';

/// Complete Video Analysis Screen with Snapshot Integration
///
/// Features:
/// - Smart video input handling (URL or file upload)
/// - Real-time snapshot capture during analysis
/// - Comprehensive emotion detection with visual feedback
/// - Optimized performance with proper animation curves
/// - Error handling and fallback demo data
/// - Responsive design with accessibility support
class EmployeeVideoAnalysisScreen extends StatefulWidget {
  const EmployeeVideoAnalysisScreen({super.key});

  @override
  State<EmployeeVideoAnalysisScreen> createState() =>
      _EmployeeVideoAnalysisScreenState();
}

class _EmployeeVideoAnalysisScreenState
    extends State<EmployeeVideoAnalysisScreen>
    with TickerProviderStateMixin {
  // Controllers and Focus
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  File? _selectedVideoFile;

  // Animation Controllers with optimized curves
  late AnimationController _headerController;
  late AnimationController _cardController;
  late AnimationController _resultsController;
  late AnimationController _backgroundController;
  late AnimationController _snapshotController;

  // Animations with clamped values
  late Animation<double> _headerAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _snapshotAnimation;

  // State tracking
  bool _isAnalyzing = false;
  String? _currentAnalysisId;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupListeners();
  }

  void _initializeAnimations() {
    // Initialize controllers with proper durations
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _resultsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _snapshotController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create animations with safe curves that don't exceed 1.0
    _headerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: Curves.easeOutQuart, // Safe curve
      ),
    );

    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardController,
        curve: Curves.easeOutCubic, // Safe curve
      ),
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );

    _snapshotAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _snapshotController, curve: Curves.easeOutBack),
    );

    // Start initial animations
    _startInitialAnimations();
  }

  void _startInitialAnimations() {
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardController.forward();
    });
    _backgroundController.repeat(reverse: true);
  }

  void _setupListeners() {
    _urlFocusNode.addListener(_onFocusChanged);
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
    _snapshotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AnalysisAppBar(
        title: 'Video Analysis',
        subtitle: 'AI-Powered Emotion Detection',
        hasUnreadNotifications: false,
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main Content with proper state management
          SafeArea(
            child: BlocListener<VideoAnalysisCubit, VideoAnalysisState>(
              listener: _handleAnalysisStateChanges,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Header with snapshot preview
                    _buildAnalysisHeader(),

                    const SizedBox(height: 24),

                    // Enhanced Video Input Section
                    _buildVideoInputSection(),

                    const SizedBox(height: 16),

                    // Sample Video Links
                    _buildSampleLinksSection(),

                    const SizedBox(height: 20),

                    // Smart Analyze Button
                    _buildAnalyzeButton(),

                    const SizedBox(height: 24),

                    // Analysis Results with Enhanced Snapshots
                    _buildAnalysisResults(),

                    const SizedBox(height: 20),

                    // Employee Insights
                    const EmployeeInsights(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle video analysis state changes
  void _handleAnalysisStateChanges(
    BuildContext context,
    VideoAnalysisState state,
  ) {
    setState(() {
      _isAnalyzing = state is VideoAnalysisLoading;
    });

    if (state is VideoAnalysisLoading) {
      // Start snapshot animation when analysis begins
      _snapshotController.forward();
    } else if (state is VideoAnalysisSuccess || state is VideoAnalysisDemo) {
      // Show results animation
      _resultsController.forward();
      HapticFeedback.mediumImpact();
    } else if (state is VideoAnalysisError) {
      // Reset animations on error
      _snapshotController.reset();
      _resultsController.reset();
      HapticFeedback.heavyImpact();
    }
  }

  /// Build analysis header with snapshot preview
  Widget _buildAnalysisHeader() {
    return AnimatedBuilder(
      animation: _headerAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _headerAnimation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _headerAnimation.value)),
            child: VideoAnalysisHeader(animation: _headerAnimation),
          ),
        );
      },
    );
  }

  /// Build enhanced video input section
  Widget _buildVideoInputSection() {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardAnimation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _cardAnimation.value)),
            child: VideoInputWidget(
              urlController: _urlController,
              urlFocusNode: _urlFocusNode,
              animation: _cardAnimation,
              onChanged: () => setState(() {}),
              onFileSelected:
                  (file) => setState(() {
                    _selectedVideoFile = file.path.isEmpty ? null : file;
                  }),
              selectedFile: _selectedVideoFile,
            ),
          ),
        );
      },
    );
  }

  /// Build sample links section
  Widget _buildSampleLinksSection() {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardAnimation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _cardAnimation.value)),
            child: VideoSampleLinksWidget(
              urlController: _urlController,
              animation: _cardAnimation,
              onSampleSelected: () => setState(() {}),
            ),
          ),
        );
      },
    );
  }

  /// Build smart analyze button
  Widget _buildAnalyzeButton() {
    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _cardAnimation.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _cardAnimation.value)),
            child: AnalyzeButton(
              animation: _cardAnimation,
              canAnalyze:
                  (_urlController.text.isNotEmpty ||
                      _selectedVideoFile != null) &&
                  !_isAnalyzing,
              onPressed: _analyzeVideo,
            ),
          ),
        );
      },
    );
  }

  /// Build analysis results with enhanced snapshots
  Widget _buildAnalysisResults() {
    return BlocBuilder<VideoAnalysisCubit, VideoAnalysisState>(
      builder: (context, state) {
        print('Current VideoAnalysisState: $state');

        if (state is VideoAnalysisLoading) {
          return _buildLoadingState();
        } else if (state is VideoAnalysisError) {
          return _buildErrorState(state.message);
        } else if (state is VideoAnalysisSuccess ||
            state is VideoAnalysisDemo) {
          return VideoAnalysisResults(resultsController: _resultsController);
        }

        return const SizedBox.shrink();
      },
    );
  }

  /// Build loading state with enhanced visual feedback
  Widget _buildLoadingState() {
    return AnimatedBuilder(
      animation: _snapshotAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _snapshotAnimation.value.clamp(0.0, 1.0),
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                // Enhanced loading animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF667EEA).withOpacity(0.8),
                        ),
                      ),
                    ),
                    EmoLoader.analysis(),
                  ],
                ),
                const SizedBox(height: 24),

                // Loading text with animation
                AnimatedBuilder(
                  animation: _backgroundController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.7 + (0.3 * _backgroundController.value),
                      child: const Column(
                        children: [
                          Text(
                            'Analyzing Video Content',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Processing frames and detecting emotions...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Progress indicators
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: const Color(0xFF10B981),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Processing: 10-15 seconds',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build error state
  Widget _buildErrorState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.error_outline, color: Colors.red, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analysis Failed',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<VideoAnalysisCubit>().reset();
              _resultsController.reset();
              _snapshotController.reset();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Analyze video with enhanced feedback and validation
  void _analyzeVideo() {
    try {
      // Generate unique analysis ID
      _currentAnalysisId = DateTime.now().millisecondsSinceEpoch.toString();

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
          // Show enhanced error feedback
          _showInputError('Please provide a video URL or select a video file');
          return;
        }
      }

      // Provide haptic feedback
      HapticFeedback.mediumImpact();

      // Clear focus from input
      _urlFocusNode.unfocus();
    } catch (e) {
      print('Error starting video analysis: $e');
      _showAnalysisError('Failed to start analysis: $e');
    }
  }

  /// Show input validation error
  void _showInputError(String message) {
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Show analysis error
  void _showAnalysisError(String message) {
    HapticFeedback.heavyImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
