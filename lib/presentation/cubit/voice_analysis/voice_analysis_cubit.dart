import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/core.dart';

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
  void loadDemoData(String analysisType) {
    emit(VoiceAnalysisDemo(_createDemoResult(analysisType)));
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
      filePath: '/audio/demo-sample.mp3',
      analysisType: analysisType,
      confidence: 0.89,
      timestamp: now,
      summary: 'Demo analysis completed successfully for $analysisType',
      details: _generateAnalysisDetails(analysisType),
      emotions: _generateEmotionData(analysisType),
      metrics: _generateMetrics(analysisType),
    );
  }

  double _generateConfidence(String analysisType) {
    switch (analysisType) {
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
}
