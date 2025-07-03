import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/analysis_result.dart';
import '../../../domain/usecases/analyze_text_usecase.dart';
import '../../../domain/usecases/analyze_voice_usecase.dart';
import '../../../domain/usecases/analyze_social_usecase.dart';
import '../../../domain/usecases/get_analysis_history_usecase.dart';
import '../../../data/services/emotion_api_service.dart';
import '../../../data/models/video_analysis_response.dart';
import '../../../data/models/video_analysis_request.dart';
import 'emotion_state.dart';

class EmotionCubit extends Cubit<EmotionState> {
  final AnalyzeTextUseCase _analyzeTextUseCase;
  final AnalyzeVoiceUseCase _analyzeVoiceUseCase;
  final AnalyzeSocialUseCase _analyzeSocialUseCase;
  final GetAnalysisHistoryUseCase _getAnalysisHistoryUseCase;
  final EmotionApiService _emotionApiService;

  VideoAnalysisResponse? _lastVideoResult;
  VideoAnalysisResponse? get lastVideoResult => _lastVideoResult;

  EmotionCubit({
    required AnalyzeTextUseCase analyzeTextUseCase,
    required AnalyzeVoiceUseCase analyzeVoiceUseCase,
    required AnalyzeSocialUseCase analyzeSocialUseCase,
    required GetAnalysisHistoryUseCase getAnalysisHistoryUseCase,
    required EmotionApiService emotionApiService,
  }) : _analyzeTextUseCase = analyzeTextUseCase,
       _analyzeVoiceUseCase = analyzeVoiceUseCase,
       _analyzeSocialUseCase = analyzeSocialUseCase,
       _getAnalysisHistoryUseCase = getAnalysisHistoryUseCase,
       _emotionApiService = emotionApiService,
       super(const EmotionInitial());

  Future<void> analyzeText(String text) async {
    emit(const EmotionLoading());
    try {
      final result = await _analyzeTextUseCase(AnalyzeTextParams(text));
      result.fold(
        (failure) => emit(EmotionError(failure.toString())),
        (analysisResult) => _updateState([analysisResult]),
      );
    } catch (e) {
      emit(EmotionError(e.toString()));
    }
  }

  Future<void> analyzeVoice(String audioPath) async {
    emit(const EmotionLoading());
    try {
      final result = await _analyzeVoiceUseCase(AnalyzeVoiceParams(audioPath));
      result.fold(
        (failure) => emit(EmotionError(failure.toString())),
        (analysisResult) => _updateState([analysisResult]),
      );
    } catch (e) {
      emit(EmotionError(e.toString()));
    }
  }

  Future<void> analyzeSocial(String socialMediaUrl) async {
    emit(const EmotionLoading());
    try {
      final result = await _analyzeSocialUseCase(
        AnalyzeSocialParams(socialMediaUrl),
      );
      result.fold(
        (failure) => emit(EmotionError(failure.toString())),
        (analysisResult) => _updateState([analysisResult]),
      );
    } catch (e) {
      emit(EmotionError(e.toString()));
    }
  }

  Future<void> analyzeVideo(
    String videoUrl, {
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    emit(const EmotionLoading());
    try {
      final request = VideoAnalysisRequest(
        videoUrl: videoUrl,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );

      final result = await _emotionApiService.analyzeVideo(request);

      _lastVideoResult = result;
      // Convert video result to analysis result for state consistency
      final analysisResult = AnalysisResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        content: videoUrl,
        primaryEmotion: _mapStringToEmotion(result.dominantEmotion),
        sentiment: result.averageConfidence,
        emotionScores: {
          _mapStringToEmotion(result.dominantEmotion): result.averageConfidence,
        },
        videoUrl: videoUrl,
      );

      _updateState([analysisResult]);
    } catch (e) {
      emit(EmotionError(e.toString()));
    }
  }

  Future<void> loadAnalysisHistory() async {
    emit(const EmotionLoading());
    try {
      final result = await _getAnalysisHistoryUseCase();
      result.fold(
        (failure) => emit(EmotionError(failure.toString())),
        (analysisResults) => _updateState(analysisResults),
      );
    } catch (e) {
      emit(EmotionError(e.toString()));
    }
  }

  void _updateState(List<AnalysisResult> newResults) {
    final currentState = state;
    if (currentState is EmotionLoaded) {
      final updatedResults = [...currentState.analysisResults, ...newResults];
      _emitLoadedState(updatedResults);
    } else {
      _emitLoadedState(newResults);
    }
  }

  void _emitLoadedState(List<AnalysisResult> results) {
    final averageSentiment = results.isEmpty
        ? 0.0
        : results.map((r) => r.sentiment).fold<double>(0.0, (a, b) => a + b) /
              results.length;

    emit(
      EmotionLoaded(
        analysisResults: results,
        averageSentiment: averageSentiment,
        totalAnalyses: results.length,
      ),
    );
  }

  // Helper method to map string emotions to Emotion enum
  Emotion _mapStringToEmotion(String emotionString) {
    switch (emotionString.toLowerCase()) {
      case 'happy':
      case 'joy':
        return Emotion.happy;
      case 'sad':
      case 'sadness':
        return Emotion.sad;
      case 'angry':
      case 'anger':
        return Emotion.angry;
      case 'surprised':
      case 'surprise':
        return Emotion.surprised;
      case 'fearful':
      case 'fear':
        return Emotion.fearful;
      default:
        return Emotion.neutral;
    }
  }
}
