import 'package:equatable/equatable.dart';

/// Domain entity representing an analysis result
class AnalysisResult extends Equatable {
  final String id;
  final DateTime timestamp;
  final String content;
  final Emotion primaryEmotion;
  final double sentiment;
  final Map<Emotion, double> emotionScores;
  final String? audioUrl;
  final String? videoUrl;
  final String? socialMediaUrl;

  const AnalysisResult({
    required this.id,
    required this.timestamp,
    required this.content,
    required this.primaryEmotion,
    required this.sentiment,
    required this.emotionScores,
    this.audioUrl,
    this.videoUrl,
    this.socialMediaUrl,
  });

  @override
  List<Object?> get props => [
    id,
    timestamp,
    content,
    primaryEmotion,
    sentiment,
    emotionScores,
    audioUrl,
    videoUrl,
    socialMediaUrl,
  ];

  @override
  bool get stringify => true;
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
  final Emotion emotion;
  final double score;

  const EmotionScore({required this.emotion, required this.score});

  @override
  List<Object> get props => [emotion, score];
}

enum Emotion { happy, sad, angry, surprised, fearful, neutral }
