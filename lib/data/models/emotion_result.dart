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
    return EmotionResult(
      emotion: json['emotion'] as String,
      sentiment: json['sentiment'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      allEmotions: Map<String, double>.from(
        (json['all_emotions'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, (value as num).toDouble()),
        ),
      ),
      processingTimeMs: json['processing_time_ms'] != null
          ? (json['processing_time_ms'] as num).toDouble()
          : null,
    );
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
