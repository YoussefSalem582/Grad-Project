import '../../domain/entities/analysis_result.dart';

class AnalysisResultModel {
  final String id;
  final String content;
  final String type;
  final SentimentScoreModel sentiment;
  final double confidence;
  final List<String> keywords;
  final List<EmotionScoreModel> emotions;
  final String createdAt;
  final String? platform;

  AnalysisResultModel({
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

  AnalysisResult toEntity() {
    return AnalysisResult(
      id: id,
      content: content,
      type: _stringToAnalysisType(type),
      sentiment: sentiment.toEntity(),
      confidence: confidence,
      keywords: keywords,
      emotions: emotions.map((e) => e.toEntity()).toList(),
      createdAt: DateTime.parse(createdAt),
      platform: platform,
    );
  }

  factory AnalysisResultModel.fromEntity(AnalysisResult entity) {
    return AnalysisResultModel(
      id: entity.id,
      content: entity.content,
      type: _analysisTypeToString(entity.type),
      sentiment: SentimentScoreModel.fromEntity(entity.sentiment),
      confidence: entity.confidence,
      keywords: entity.keywords,
      emotions: entity.emotions
          .map((e) => EmotionScoreModel.fromEntity(e))
          .toList(),
      createdAt: entity.createdAt.toIso8601String(),
      platform: entity.platform,
    );
  }

  static AnalysisType _stringToAnalysisType(String type) {
    switch (type) {
      case 'text':
        return AnalysisType.text;
      case 'voice':
        return AnalysisType.voice;
      case 'social':
        return AnalysisType.social;
      default:
        return AnalysisType.text;
    }
  }

  static String _analysisTypeToString(AnalysisType type) {
    switch (type) {
      case AnalysisType.text:
        return 'text';
      case AnalysisType.voice:
        return 'voice';
      case AnalysisType.social:
        return 'social';
    }
  }
}

class SentimentScoreModel {
  final String type;
  final double score;

  SentimentScoreModel({required this.type, required this.score});

  SentimentScore toEntity() {
    return SentimentScore(type: _stringToSentimentType(type), score: score);
  }

  factory SentimentScoreModel.fromEntity(SentimentScore entity) {
    return SentimentScoreModel(
      type: _sentimentTypeToString(entity.type),
      score: entity.score,
    );
  }

  static SentimentType _stringToSentimentType(String type) {
    switch (type) {
      case 'positive':
        return SentimentType.positive;
      case 'negative':
        return SentimentType.negative;
      case 'neutral':
        return SentimentType.neutral;
      default:
        return SentimentType.neutral;
    }
  }

  static String _sentimentTypeToString(SentimentType type) {
    switch (type) {
      case SentimentType.positive:
        return 'positive';
      case SentimentType.negative:
        return 'negative';
      case SentimentType.neutral:
        return 'neutral';
    }
  }
}

class EmotionScoreModel {
  final String emotion;
  final double score;

  EmotionScoreModel({required this.emotion, required this.score});

  EmotionScore toEntity() {
    return EmotionScore(emotion: _stringToEmotionType(emotion), score: score);
  }

  factory EmotionScoreModel.fromEntity(EmotionScore entity) {
    return EmotionScoreModel(
      emotion: _emotionTypeToString(entity.emotion),
      score: entity.score,
    );
  }

  static EmotionType _stringToEmotionType(String emotion) {
    switch (emotion) {
      case 'happy':
        return EmotionType.happy;
      case 'sad':
        return EmotionType.sad;
      case 'angry':
        return EmotionType.angry;
      case 'surprised':
        return EmotionType.surprised;
      case 'fearful':
        return EmotionType.fearful;
      case 'disgusted':
        return EmotionType.disgusted;
      case 'calm':
        return EmotionType.calm;
      case 'excited':
        return EmotionType.excited;
      default:
        return EmotionType.calm;
    }
  }

  static String _emotionTypeToString(EmotionType emotion) {
    switch (emotion) {
      case EmotionType.happy:
        return 'happy';
      case EmotionType.sad:
        return 'sad';
      case EmotionType.angry:
        return 'angry';
      case EmotionType.surprised:
        return 'surprised';
      case EmotionType.fearful:
        return 'fearful';
      case EmotionType.disgusted:
        return 'disgusted';
      case EmotionType.calm:
        return 'calm';
      case EmotionType.excited:
        return 'excited';
    }
  }
}
