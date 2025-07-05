part of 'text_analysis_cubit.dart';

abstract class TextAnalysisState extends Equatable {
  const TextAnalysisState();

  @override
  List<Object?> get props => [];
}

class TextAnalysisInitial extends TextAnalysisState {
  const TextAnalysisInitial();
}

class TextAnalysisLoading extends TextAnalysisState {
  const TextAnalysisLoading();
}

class TextAnalysisSuccess extends TextAnalysisState {
  final TextAnalysisResult result;

  const TextAnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class TextAnalysisError extends TextAnalysisState {
  final String message;

  const TextAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

class TextAnalysisDemo extends TextAnalysisState {
  final TextAnalysisResult demoResult;

  const TextAnalysisDemo(this.demoResult);

  @override
  List<Object?> get props => [demoResult];
}

/// Text Analysis Result Model
class TextAnalysisResult extends Equatable {
  final String id;
  final String text;
  final String analysisType;
  final double confidence;
  final DateTime timestamp;
  final String summary;
  final List<String> details;
  final Map<String, double> sentiments;
  final List<String> keywords;
  final Map<String, dynamic> metrics;

  const TextAnalysisResult({
    required this.id,
    required this.text,
    required this.analysisType,
    required this.confidence,
    required this.timestamp,
    required this.summary,
    required this.details,
    required this.sentiments,
    required this.keywords,
    required this.metrics,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    analysisType,
    confidence,
    timestamp,
    summary,
    details,
    sentiments,
    keywords,
    metrics,
  ];

  /// Convert to Map format for compatibility with existing widgets
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'text',
      'title': 'Text Analysis Results',
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'details': details,
      'sentiments': sentiments,
      'keywords': keywords,
      'metrics': metrics,
      'analysisType': analysisType,
      'originalText': text,
    };
  }
}
