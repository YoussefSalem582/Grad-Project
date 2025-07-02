import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/analysis_result.dart';
import '../../../domain/usecases/analyze_text_usecase.dart';
import '../../../domain/usecases/analyze_voice_usecase.dart';
import '../../../domain/usecases/analyze_social_usecase.dart';
import '../../../domain/usecases/get_analysis_history_usecase.dart';
import 'emotion_state.dart';

class EmotionCubit extends Cubit<EmotionState> {
  final AnalyzeTextUseCase _analyzeTextUseCase;
  final AnalyzeVoiceUseCase _analyzeVoiceUseCase;
  final AnalyzeSocialUseCase _analyzeSocialUseCase;
  final GetAnalysisHistoryUseCase _getAnalysisHistoryUseCase;

  EmotionCubit({
    required AnalyzeTextUseCase analyzeTextUseCase,
    required AnalyzeVoiceUseCase analyzeVoiceUseCase,
    required AnalyzeSocialUseCase analyzeSocialUseCase,
    required GetAnalysisHistoryUseCase getAnalysisHistoryUseCase,
  }) : _analyzeTextUseCase = analyzeTextUseCase,
       _analyzeVoiceUseCase = analyzeVoiceUseCase,
       _analyzeSocialUseCase = analyzeSocialUseCase,
       _getAnalysisHistoryUseCase = getAnalysisHistoryUseCase,
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
}
