import '../../domain/entities/analysis_result.dart';

class AnalysisResultModel {
  final String id;
  final DateTime timestamp;
  final String content;
  final Emotion primaryEmotion;
  final double sentiment;
  final Map<Emotion, double> emotionScores;
  final String? audioUrl;
  final String? videoUrl;
  final String? socialMediaUrl;

  const AnalysisResultModel({
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

  factory AnalysisResultModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResultModel(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      content: json['content'] as String,
      primaryEmotion: _stringToEmotion(json['primary_emotion'] as String),
      sentiment: (json['sentiment'] as num).toDouble(),
      emotionScores: (json['emotion_scores'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(_stringToEmotion(key), (value as num).toDouble()),
      ),
      audioUrl: json['audio_url'] as String?,
      videoUrl: json['video_url'] as String?,
      socialMediaUrl: json['social_media_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'content': content,
      'primary_emotion': _emotionToString(primaryEmotion),
      'sentiment': sentiment,
      'emotion_scores': emotionScores.map(
        (key, value) => MapEntry(_emotionToString(key), value),
      ),
      'audio_url': audioUrl,
      'video_url': videoUrl,
      'social_media_url': socialMediaUrl,
    };
  }

  factory AnalysisResultModel.fromEntity(AnalysisResult entity) {
    return AnalysisResultModel(
      id: entity.id,
      timestamp: entity.timestamp,
      content: entity.content,
      primaryEmotion: entity.primaryEmotion,
      sentiment: entity.sentiment,
      emotionScores: entity.emotionScores,
      audioUrl: entity.audioUrl,
      videoUrl: entity.videoUrl,
      socialMediaUrl: entity.socialMediaUrl,
    );
  }

  AnalysisResult toEntity() {
    return AnalysisResult(
      id: id,
      timestamp: timestamp,
      content: content,
      primaryEmotion: primaryEmotion,
      sentiment: sentiment,
      emotionScores: emotionScores,
      audioUrl: audioUrl,
      videoUrl: videoUrl,
      socialMediaUrl: socialMediaUrl,
    );
  }

  static String _emotionToString(Emotion emotion) {
    return emotion.name.toLowerCase();
  }

  static Emotion _stringToEmotion(String emotion) {
    return Emotion.values.firstWhere(
      (e) => e.name.toLowerCase() == emotion.toLowerCase(),
      orElse: () => Emotion.neutral,
    );
  }
}
