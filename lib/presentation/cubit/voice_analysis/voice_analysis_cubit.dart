import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'voice_analysis_state.dart';

class VoiceAnalysisCubit extends Cubit<VoiceAnalysisState> {
  VoiceAnalysisCubit() : super(const VoiceAnalysisInitial());

  /// Analyze audio file from path
  Future<void> analyzeAudio({
    required String filePath,
    required String analysisType,
  }) async {
    if (filePath.trim().isEmpty) {
      emit(const VoiceAnalysisError('Audio file path cannot be empty'));
      return;
    }

    if (!_isValidAudioFile(filePath)) {
      emit(
        const VoiceAnalysisError(
          'Invalid audio file format. Please use MP3, WAV, or M4A',
        ),
      );
      return;
    }

    emit(const VoiceAnalysisLoading());

    try {
      // Simulate analysis process
      await Future.delayed(const Duration(seconds: 3));

      final result = _createAnalysisResult(filePath, analysisType);
      emit(VoiceAnalysisSuccess(result));
    } catch (e) {
      emit(VoiceAnalysisError('Analysis failed: ${e.toString()}'));
    }
  }

  /// Load demo data for testing
  Future<void> loadDemoData(String analysisType) async {
    emit(const VoiceAnalysisLoading());

    try {
      // Simulate analysis processing time
      await Future.delayed(const Duration(seconds: 2));

      final demoResult = _createDemoResult(analysisType);
      emit(VoiceAnalysisDemo(demoResult));
    } catch (e) {
      emit(VoiceAnalysisError('Demo analysis failed: ${e.toString()}'));
    }
  }

  /// Reset to initial state
  void reset() {
    emit(const VoiceAnalysisInitial());
  }

  /// Clear current analysis
  void clearAnalysis() {
    emit(const VoiceAnalysisInitial());
  }

  /// Validate audio file path
  bool _isValidAudioFile(String path) {
    final validExtensions = ['.mp3', '.wav', '.m4a'];
    return validExtensions.any((ext) => path.toLowerCase().endsWith(ext)) ||
        path.startsWith('/audio/'); // Sample files
  }

  /// Create analysis result based on type
  VoiceAnalysisResult _createAnalysisResult(
    String filePath,
    String analysisType,
  ) {
    final now = DateTime.now();

    return VoiceAnalysisResult(
      id: now.millisecondsSinceEpoch.toString(),
      filePath: filePath,
      analysisType: analysisType,
      confidence: _generateConfidence(analysisType),
      timestamp: now,
      summary: _generateSummary(analysisType),
      details: _generateAnalysisDetails(analysisType),
      emotions: _generateEmotionData(analysisType),
      metrics: _generateMetrics(analysisType),
    );
  }

  /// Create demo result for testing
  VoiceAnalysisResult _createDemoResult(String analysisType) {
    final now = DateTime.now();

    return VoiceAnalysisResult(
      id: 'demo_${now.millisecondsSinceEpoch}',
      filePath: _getDemoFilePath(analysisType),
      analysisType: analysisType,
      confidence: _generateConfidence(analysisType),
      timestamp: now,
      summary: _generateSummary(analysisType),
      details: _generateAnalysisDetails(analysisType),
      emotions: _generateEmotionData(analysisType),
      metrics: _generateDemoMetrics(analysisType),
    );
  }

  String _getDemoFilePath(String analysisType) {
    switch (analysisType) {
      case 'Customer Support Analysis':
        return '/audio/samples/customer_service_call.mp3';
      case 'Business Communication Analysis':
        return '/audio/samples/sales_meeting.wav';
      case 'Interview Performance Analysis':
        return '/audio/samples/interview_session.mp3';
      case 'Personal Voice Analysis':
        return '/audio/samples/voice_message.m4a';
      default:
        return '/audio/demo-sample.mp3';
    }
  }

  double _generateConfidence(String analysisType) {
    switch (analysisType) {
      case 'Customer Support Analysis':
        return 0.91;
      case 'Business Communication Analysis':
        return 0.88;
      case 'Interview Performance Analysis':
        return 0.76;
      case 'Personal Voice Analysis':
        return 0.94;
      case 'Emotion Analysis':
        return 0.87;
      case 'Communication Style':
        return 0.92;
      case 'Confidence Level':
        return 0.85;
      case 'Speech Patterns':
        return 0.90;
      case 'Sentiment Analysis':
        return 0.88;
      default:
        return 0.85;
    }
  }

  String _generateSummary(String analysisType) {
    switch (analysisType) {
      case 'Customer Support Analysis':
        return 'Professional customer service tone with high empathy and patience levels detected';
      case 'Business Communication Analysis':
        return 'Confident business presentation style with strong authority and enthusiasm';
      case 'Interview Performance Analysis':
        return 'Moderate confidence levels with some nervousness, showing professional communication';
      case 'Personal Voice Analysis':
        return 'Very positive and happy personal communication with high emotional engagement';
      case 'Emotion Analysis':
        return 'Positive emotional tone detected with high confidence levels';
      case 'Communication Style':
        return 'Professional and clear communication style identified';
      case 'Confidence Level':
        return 'High confidence and authority indicators present';
      case 'Speech Patterns':
        return 'Consistent speech rhythm with minimal hesitation';
      case 'Sentiment Analysis':
        return 'Overall positive sentiment with engaging delivery';
      default:
        return 'Analysis completed successfully';
    }
  }

  List<String> _generateAnalysisDetails(String analysisType) {
    switch (analysisType) {
      case 'Customer Support Analysis':
        return [
          'Professional tone: Excellent (89%)',
          'Empathy indicators: High (78%)',
          'Problem-solving approach: Clear',
          'Customer satisfaction likely: Very High',
        ];
      case 'Business Communication Analysis':
        return [
          'Authority presence: Strong (85%)',
          'Persuasiveness: High (82%)',
          'Clarity of message: Excellent',
          'Executive presence: Confident',
        ];
      case 'Interview Performance Analysis':
        return [
          'Confidence level: Moderate (65%)',
          'Nervousness detected: Some (25%)',
          'Communication clarity: Good',
          'Professional demeanor: Strong',
        ];
      case 'Personal Voice Analysis':
        return [
          'Emotional positivity: Very High (95%)',
          'Energy level: Enthusiastic',
          'Authenticity: Genuine',
          'Overall mood: Happy and engaged',
        ];
      case 'Emotion Analysis':
        return [
          'Dominant emotion: Confidence (72%)',
          'Secondary emotion: Enthusiasm (18%)',
          'Stress indicators: Low (10%)',
          'Overall emotional tone: Positive',
        ];
      case 'Communication Style':
        return [
          'Speaking pace: Moderate (145 WPM)',
          'Clarity: High (92%)',
          'Articulation: Clear and precise',
          'Communication style: Professional',
        ];
      case 'Confidence Level':
        return [
          'Overall confidence: High (85%)',
          'Voice stability: Excellent',
          'Hesitation frequency: Low',
          'Authority indicators: Strong',
        ];
      case 'Speech Patterns':
        return [
          'Average pause duration: 0.8 seconds',
          'Filler words frequency: Low (2%)',
          'Repetition patterns: Minimal',
          'Speech rhythm: Consistent',
        ];
      case 'Sentiment Analysis':
        return [
          'Overall sentiment: Positive (78%)',
          'Positive indicators: High engagement',
          'Negative indicators: Minimal concern',
          'Neutral content: 15%',
        ];
      default:
        return [
          'Analysis completed successfully',
          'Results are ready for review',
        ];
    }
  }

  Map<String, double> _generateEmotionData(String analysisType) {
    switch (analysisType) {
      case 'Customer Support Analysis':
        return {
          'Professional': 0.65,
          'Empathy': 0.22,
          'Patience': 0.10,
          'Stress': 0.03,
        };
      case 'Business Communication Analysis':
        return {
          'Confidence': 0.78,
          'Enthusiasm': 0.15,
          'Professional': 0.05,
          'Authority': 0.02,
        };
      case 'Interview Performance Analysis':
        return {
          'Confidence': 0.45,
          'Nervousness': 0.25,
          'Professionalism': 0.20,
          'Enthusiasm': 0.10,
        };
      case 'Personal Voice Analysis':
        return {
          'Happiness': 0.82,
          'Excitement': 0.12,
          'Relaxed': 0.05,
          'Neutral': 0.01,
        };
      case 'Emotion Analysis':
        return {
          'Confidence': 0.72,
          'Enthusiasm': 0.18,
          'Calm': 0.08,
          'Stress': 0.02,
        };
      case 'Communication Style':
        return {'Professional': 0.85, 'Friendly': 0.10, 'Authoritative': 0.05};
      case 'Confidence Level':
        return {
          'High Confidence': 0.85,
          'Moderate Confidence': 0.12,
          'Low Confidence': 0.03,
        };
      case 'Sentiment Analysis':
        return {'Positive': 0.78, 'Neutral': 0.15, 'Negative': 0.07};
      default:
        return {'Positive': 0.75, 'Neutral': 0.20, 'Negative': 0.05};
    }
  }

  Map<String, dynamic> _generateMetrics(String analysisType) {
    return {
      'duration': '4:32',
      'wordsPerMinute': 145,
      'pauseFrequency': 'Low',
      'volumeConsistency': 'High',
      'clarityScore': 0.92,
      'engagementLevel': 'High',
    };
  }

  Map<String, dynamic> _generateDemoMetrics(String analysisType) {
    switch (analysisType) {
      case 'Customer Support Analysis':
        return {
          'duration': '3:24',
          'wordsPerMinute': 135,
          'pauseFrequency': 'Low',
          'volumeConsistency': 'Very High',
          'clarityScore': 0.95,
          'engagementLevel': 'Professional',
          'empathyScore': 0.88,
          'problemSolvingApproach': 'Structured',
        };
      case 'Business Communication Analysis':
        return {
          'duration': '12:15',
          'wordsPerMinute': 160,
          'pauseFrequency': 'Very Low',
          'volumeConsistency': 'High',
          'clarityScore': 0.93,
          'engagementLevel': 'Very High',
          'authorityPresence': 0.91,
          'persuasiveness': 0.87,
        };
      case 'Interview Performance Analysis':
        return {
          'duration': '8:47',
          'wordsPerMinute': 125,
          'pauseFrequency': 'Moderate',
          'volumeConsistency': 'Moderate',
          'clarityScore': 0.85,
          'engagementLevel': 'Good',
          'nervousnessIndicators': 0.25,
          'professionalismScore': 0.82,
        };
      case 'Personal Voice Analysis':
        return {
          'duration': '1:32',
          'wordsPerMinute': 170,
          'pauseFrequency': 'Low',
          'volumeConsistency': 'High',
          'clarityScore': 0.90,
          'engagementLevel': 'Very High',
          'emotionalExpressiveness': 0.95,
          'authenticity': 0.93,
        };
      default:
        return {
          'duration': '4:32',
          'wordsPerMinute': 145,
          'pauseFrequency': 'Low',
          'volumeConsistency': 'High',
          'clarityScore': 0.92,
          'engagementLevel': 'High',
        };
    }
  }
}
