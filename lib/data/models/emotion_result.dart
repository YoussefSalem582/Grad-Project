import 'package:equatable/equatable.dart';

class EmotionResult extends Equatable {
  final String emotion;
  final String sentiment;
  final double confidence;
  final Map<String, double> allEmotions;
  final double? processingTimeMs;

  const EmotionResult({
    required this.emotion,
    required this.sentiment,
    required this.confidence,
    required this.allEmotions,
    this.processingTimeMs,
  });

  factory EmotionResult.fromJson(Map<String, dynamic> json) {
    // Handle backend response format
    if (json.containsKey('emotion') && json.containsKey('processing_time')) {
      // Backend response format
      final emotion = json['emotion'] as String;
      final processingTime = (json['processing_time'] as num).toDouble();

      return EmotionResult(
        emotion: emotion,
        sentiment: _emotionToSentiment(emotion),
        confidence: 0.85, // Default confidence since backend doesn't provide it
        allEmotions: {emotion: 0.85},
        processingTimeMs: processingTime * 1000, // Convert to ms
      );
    } else {
      // Original format
      return EmotionResult(
        emotion: json['emotion'] as String,
        sentiment: json['sentiment'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        allEmotions: Map<String, double>.from(
          (json['all_emotions'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
          ),
        ),
        processingTimeMs:
            json['processing_time_ms'] != null
                ? (json['processing_time_ms'] as num).toDouble()
                : null,
      );
    }
  }

  static String _emotionToSentiment(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
      case 'surprise':
        return 'positive';
      case 'sadness':
      case 'anger':
      case 'fear':
      case 'disgust':
        return 'negative';
      case 'neutral':
      default:
        return 'neutral';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'emotion': emotion,
      'sentiment': sentiment,
      'confidence': confidence,
      'all_emotions': allEmotions,
      if (processingTimeMs != null) 'processing_time_ms': processingTimeMs,
    };
  }

  EmotionResult copyWith({
    String? emotion,
    String? sentiment,
    double? confidence,
    Map<String, double>? allEmotions,
    double? processingTimeMs,
  }) {
    return EmotionResult(
      emotion: emotion ?? this.emotion,
      sentiment: sentiment ?? this.sentiment,
      confidence: confidence ?? this.confidence,
      allEmotions: allEmotions ?? this.allEmotions,
      processingTimeMs: processingTimeMs ?? this.processingTimeMs,
    );
  }

  @override
  List<Object?> get props => [
    emotion,
    sentiment,
    confidence,
    allEmotions,
    processingTimeMs,
  ];

  @override
  String toString() {
    return 'EmotionResult(emotion: $emotion, sentiment: $sentiment, confidence: $confidence, allEmotions: $allEmotions, processingTimeMs: $processingTimeMs)';
  }
}
