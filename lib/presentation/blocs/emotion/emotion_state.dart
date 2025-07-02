import '../../../domain/entities/analysis_result.dart';

sealed class EmotionState {
  const EmotionState();
}

class EmotionInitial extends EmotionState {
  const EmotionInitial();
}

class EmotionLoading extends EmotionState {
  const EmotionLoading();
}

class EmotionLoaded extends EmotionState {
  final List<AnalysisResult> analysisResults;
  final double averageSentiment;
  final int totalAnalyses;

  const EmotionLoaded({
    required this.analysisResults,
    required this.averageSentiment,
    required this.totalAnalyses,
  });
}

class EmotionError extends EmotionState {
  final String message;

  const EmotionError(this.message);
}
