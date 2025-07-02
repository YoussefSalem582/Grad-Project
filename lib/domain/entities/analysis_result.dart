import 'package:equatable/equatable.dart';

/// Domain entity representing an analysis result
class AnalysisResult extends Equatable {
  final String id;
  final String content;
  final AnalysisType type;
  final SentimentScore sentiment;
  final double confidence;
  final List<String> keywords;
  final List<EmotionScore> emotions;
  final DateTime createdAt;
  final String? platform;

  const AnalysisResult({
    required this.id,
    required this.content,
    required this.type,
    required this.sentiment,
    required this.confidence,
    required this.keywords,
    required this.emotions,
    required this.createdAt,
    this.platform,
  });

  @override
  List<Object?> get props => [
    id,
    content,
    type,
    sentiment,
    confidence,
    keywords,
    emotions,
    createdAt,
    platform,
  ];
}

enum AnalysisType { text, voice, social }

class SentimentScore extends Equatable {
  final SentimentType type;
  final double score;

  const SentimentScore({required this.type, required this.score});

  @override
  List<Object> get props => [type, score];
}

enum SentimentType { positive, negative, neutral }

class EmotionScore extends Equatable {
  final EmotionType emotion;
  final double score;

  const EmotionScore({required this.emotion, required this.score});

  @override
  List<Object> get props => [emotion, score];
}

enum EmotionType {
  happy,
  sad,
  angry,
  surprised,
  fearful,
  disgusted,
  calm,
  excited,
}
