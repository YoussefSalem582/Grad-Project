import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart' as di;
import '../../../cubit/voice_analysis/voice_analysis_cubit.dart';
import '../../../widgets/common/animated_background_widget.dart';
import '../../../widgets/app_bars/analysis_app_bar.dart';
import 'widgets/widgets.dart';

/// Unified Voice Analysis Screen - Refactored with Modular Widgets
///
/// Comprehensive voice analysis interface supporting:
/// - Recorded Calls Analysis
/// - Voice Message Analysis
/// - Audio File Upload
/// - Real-time voice processing
/// - Call quality assessment
class UnifiedVoiceAnalysisScreen extends StatefulWidget {
  const UnifiedVoiceAnalysisScreen({super.key});

  @override
  State<UnifiedVoiceAnalysisScreen> createState() =>
      _UnifiedVoiceAnalysisScreenState();
}

class _UnifiedVoiceAnalysisScreenState extends State<UnifiedVoiceAnalysisScreen>
    with SingleTickerProviderStateMixin {
  // Controllers
  final TextEditingController _callIdController = TextEditingController();

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;

  // State variables
  String _selectedAudioSource = 'upload';
  bool _isRecording = false;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _callIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<VoiceAnalysisCubit>(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: const AnalysisAppBar(
          title: 'Voice Analysis Hub',
          subtitle: 'Audio Emotion Analysis',
          hasUnreadNotifications: true,
          notificationCount: 1,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              // Animated Background
              Positioned.fill(
                child: AnimatedBackgroundWidget(
                  animation: _backgroundAnimation,
                ),
              ),
              // Content
              BlocBuilder<VoiceAnalysisCubit, VoiceAnalysisState>(
                builder: (context, state) {
                  return AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildBody(context, state),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, VoiceAnalysisState state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Audio Source Selector
              VoiceAnalysisSourceSelector(
                selectedSource: _selectedAudioSource,
                onSourceChanged: (source) {
                  setState(() {
                    _selectedAudioSource = source;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Dynamic Content Based on Selected Source
              _buildSourceSpecificContent(),
              const SizedBox(height: 20),

              // Sample Files Section
              VoiceAnalysisSamplesSection(
                onSampleSelected: (sampleTitle) {
                  _loadSampleFile(sampleTitle);
                },
              ),
              const SizedBox(height: 20),

              // Action Buttons
              VoiceAnalysisActionButtons(
                isAnalyzing: _isAnalyzing,
                onAnalyze: _startAnalysis,
                onClear: _clearContent,
                hasContent: _hasContent(),
              ),
              const SizedBox(height: 20),

              // Results Display
              VoiceAnalysisResultsDisplay(
                analysisResults: _getAnalysisResults(state),
                isLoading: _isAnalyzing,
              ),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSourceSpecificContent() {
    switch (_selectedAudioSource) {
      case 'upload':
        return VoiceAnalysisFileUploadSection(
          onFileSelected: (fileName) {
            _handleFileUpload(fileName);
          },
        );
      case 'record':
        return VoiceAnalysisRecordingSection(
          isRecording: _isRecording,
          onRecordingToggle: _toggleRecording,
        );
      case 'call':
        return VoiceAnalysisCallInputSection(
          callIdController: _callIdController,
          onFetchCall: _fetchCallRecording,
        );
      default:
        return VoiceAnalysisFileUploadSection(
          onFileSelected: (fileName) {
            _handleFileUpload(fileName);
          },
        );
    }
  }

  // Event Handlers
  void _handleFileUpload(String fileName) {
    // Handle file upload logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File uploaded: $fileName'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );

    // Set content flag for analysis
    setState(() {
      // File is now available for analysis
    });
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });

    HapticFeedback.mediumImpact();

    if (_isRecording) {
      // Start recording logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started...'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
    } else {
      // Stop recording logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording stopped'),
          backgroundColor: Color(0xFF64748B),
        ),
      );
    }
  }

  void _fetchCallRecording() {
    final callId = _callIdController.text.trim();
    if (callId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a call ID'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    // Fetch call recording logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fetching call recording: $callId'),
        backgroundColor: const Color(0xFF3B82F6),
      ),
    );
  }

  void _loadSampleFile(String sampleTitle) {
    // Load sample file logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded sample: $sampleTitle'),
        backgroundColor: const Color(0xFFF59E0B),
      ),
    );
  }

  void _startAnalysis() {
    setState(() {
      _isAnalyzing = true;
    });

    // Simulate analysis delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
        });

        // Trigger analysis with mock results
        context.read<VoiceAnalysisCubit>().analyzeAudio(
          filePath: '/audio/mock_audio_data.mp3',
          analysisType: 'Emotion Analysis',
        );
      }
    });

    HapticFeedback.lightImpact();
  }

  void _clearContent() {
    setState(() {
      _callIdController.clear();
      _isRecording = false;
      _isAnalyzing = false;
    });

    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content cleared'),
        backgroundColor: Color(0xFF64748B),
      ),
    );
  }

  bool _hasContent() {
    // Check if there's any content to analyze
    return _callIdController.text.isNotEmpty ||
        _selectedAudioSource == 'upload' ||
        _selectedAudioSource == 'record' ||
        _isRecording;
  }

  Map<String, dynamic>? _getAnalysisResults(VoiceAnalysisState state) {
    if (state is VoiceAnalysisSuccess) {
      return {
        'overall_score': 0.85,
        'dominant_emotion': 'Happy',
        'emotions': {
          'happy': 0.75,
          'confident': 0.65,
          'calm': 0.45,
          'excited': 0.35,
        },
        'metrics': {
          'clarity': '92%',
          'pace': 'Normal',
          'volume': 'Appropriate',
          'tone': 'Professional',
        },
        'transcription':
            'Hello, thank you for calling our customer support. How can I assist you today? I understand your concern and I will be happy to help resolve this issue for you.',
      };
    }
    return null;
  }
}
