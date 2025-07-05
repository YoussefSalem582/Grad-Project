part of 'voice_analysis_cubit.dart';

abstract class VoiceAnalysisState extends Equatable {
  const VoiceAnalysisState();

  @override
  List<Object?> get props => [];
}

class VoiceAnalysisInitial extends VoiceAnalysisState {
  const VoiceAnalysisInitial();
}

class VoiceAnalysisLoading extends VoiceAnalysisState {
  const VoiceAnalysisLoading();
}

class VoiceAnalysisSuccess extends VoiceAnalysisState {
  final VoiceAnalysisResult result;

  const VoiceAnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class VoiceAnalysisError extends VoiceAnalysisState {
  final String message;

  const VoiceAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

class VoiceAnalysisDemo extends VoiceAnalysisState {
  final VoiceAnalysisResult demoResult;

  const VoiceAnalysisDemo(this.demoResult);

  @override
  List<Object?> get props => [demoResult];
}

/// Voice Analysis Result Model
class VoiceAnalysisResult extends Equatable {
  final String id;
  final String filePath;
  final String analysisType;
  final double confidence;
  final DateTime timestamp;
  final String summary;
  final List<String> details;
  final Map<String, double> emotions;
  final Map<String, dynamic> metrics;

  const VoiceAnalysisResult({
    required this.id,
    required this.filePath,
    required this.analysisType,
    required this.confidence,
    required this.timestamp,
    required this.summary,
    required this.details,
    required this.emotions,
    required this.metrics,
  });

  @override
  List<Object?> get props => [
    id,
    filePath,
    analysisType,
    confidence,
    timestamp,
    summary,
    details,
    emotions,
    metrics,
  ];

  /// Convert to Map format for compatibility with existing widgets
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'voice',
      'title': 'Audio Analysis Results',
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'details': details,
      'emotions': emotions,
      'metrics': metrics,
      'analysisType': analysisType,
      'filePath': filePath,
    };
  }
}
