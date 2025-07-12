import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/services/emotion_api_service.dart';
import '../../../data/models/emotion_result.dart';

part 'analysis_state.dart';

/// Cubit for managing general analysis operations
class AnalysisCubit extends Cubit<AnalysisState> {
  final EmotionApiService _apiService;

  AnalysisCubit(this._apiService) : super(const AnalysisInitial());

  /// Analyze text content using real API
  Future<void> analyzeText(String content) async {
    if (content.trim().isEmpty) {
      emit(const AnalysisError('Text cannot be empty'));
      return;
    }

    emit(const AnalysisLoading());

    try {
      final result = await _apiService.predictEmotion(content);
      final analysisResult = _convertEmotionToAnalysis(result, content, 'text');
      emit(AnalysisSuccess(analysisResult, [analysisResult]));
    } catch (e) {
      emit(AnalysisError('Analysis failed: ${e.toString()}'));
    }
  }

  /// Analyze voice content (placeholder implementation)
  Future<void> analyzeVoice(String audioPath) async {
    emit(const AnalysisLoading());

    try {
      // TODO: Implement voice analysis when audio endpoint is available
      await Future.delayed(const Duration(seconds: 3));
      final result = _createMockResult(audioPath, 'voice');
      emit(AnalysisSuccess(result, [result]));
    } catch (e) {
      emit(AnalysisError('Voice analysis failed: ${e.toString()}'));
    }
  }

  /// Analyze social media content (placeholder implementation)
  Future<void> analyzeSocial(String socialData) async {
    emit(const AnalysisLoading());

    try {
      // TODO: Implement social analysis when social endpoint is available
      await Future.delayed(const Duration(seconds: 2));
      final result = _createMockResult(socialData, 'social');
      emit(AnalysisSuccess(result, [result]));
    } catch (e) {
      emit(AnalysisError('Social analysis failed: ${e.toString()}'));
    }
  }

  /// Clear current result
  void clearResult() {
    emit(const AnalysisInitial());
  }

  /// Clear error
  void clearError() {
    if (state is AnalysisError) {
      emit(const AnalysisInitial());
    }
  }

  /// Convert EmotionResult to analysis result format
  Map<String, dynamic> _convertEmotionToAnalysis(
    EmotionResult emotionResult,
    String content,
    String type,
  ) {
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': content,
      'type': type,
      'emotion': emotionResult.emotion,
      'sentiment': emotionResult.sentiment,
      'confidence': emotionResult.confidence,
      'timestamp': DateTime.now().toIso8601String(),
      'emotions': emotionResult.allEmotions,
      'keywords': _extractKeywords(content),
      'processing_time': emotionResult.processingTimeMs,
    };
  }

  /// Extract keywords from content (simple implementation)
  List<String> _extractKeywords(String content) {
    final words = content.toLowerCase().split(RegExp(r'\W+'));
    return words.where((word) => word.length > 3).take(5).toList();
  }

  Map<String, dynamic> _createMockResult(String content, String type) {
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'content': content,
      'type': type,
      'confidence': 0.85 + (DateTime.now().millisecond % 15) / 100,
      'timestamp': DateTime.now().toIso8601String(),
      'emotions': {'positive': 0.7, 'negative': 0.2, 'neutral': 0.1},
      'keywords': ['analysis', 'emotion', 'sentiment'],
    };
  }
}
