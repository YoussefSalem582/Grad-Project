import 'package:equatable/equatable.dart';
import 'emotion_result.dart';

class DemoResult extends Equatable {
  final List<DemoExample> examples;
  final String message;
  final String timestamp;
  final int totalExamples;

  const DemoResult({
    required this.examples,
    required this.message,
    required this.timestamp,
    required this.totalExamples,
  });

  factory DemoResult.fromJson(Map<String, dynamic> json) {
    return DemoResult(
      examples:
          (json['examples'] as List?)
              ?.map(
                (item) => DemoExample.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      message: json['message'] as String? ?? '',
      timestamp:
          json['timestamp'] as String? ?? DateTime.now().toIso8601String(),
      totalExamples: json['total_examples'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'examples': examples.map((example) => example.toJson()).toList(),
      'message': message,
      'timestamp': timestamp,
      'total_examples': totalExamples,
    };
  }

  List<DemoExample> get highConfidenceExamples {
    return examples.where((example) => example.confidence > 0.8).toList();
  }

  Map<String, List<DemoExample>> get examplesByEmotion {
    final grouped = <String, List<DemoExample>>{};
    for (final example in examples) {
      grouped.putIfAbsent(example.emotion, () => []).add(example);
    }
    return grouped;
  }

  @override
  List<Object?> get props => [examples, message, timestamp, totalExamples];
}

class DemoExample extends Equatable {
  final String text;
  final String emotion;
  final String sentiment;
  final double confidence;
  final Map<String, double> allEmotions;
  final double? processingTimeMs;
  final String category;

  const DemoExample({
    required this.text,
    required this.emotion,
    required this.sentiment,
    required this.confidence,
    required this.allEmotions,
    this.processingTimeMs,
    required this.category,
  });

  factory DemoExample.fromJson(Map<String, dynamic> json) {
    return DemoExample(
      text: json['text'] as String? ?? '',
      emotion: json['emotion'] as String? ?? '',
      sentiment: json['sentiment'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      allEmotions: Map<String, double>.from(
        (json['all_emotions'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
            ) ??
            {},
      ),
      processingTimeMs: (json['processing_time_ms'] as num?)?.toDouble(),
      category: json['category'] as String? ?? 'general',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'emotion': emotion,
      'sentiment': sentiment,
      'confidence': confidence,
      'all_emotions': allEmotions,
      if (processingTimeMs != null) 'processing_time_ms': processingTimeMs,
      'category': category,
    };
  }

  EmotionResult toEmotionResult() {
    return EmotionResult(
      emotion: emotion,
      sentiment: sentiment,
      confidence: confidence,
      allEmotions: allEmotions,
      processingTimeMs: processingTimeMs,
    );
  }

  String get confidenceFormatted {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }

  String get processingTimeFormatted {
    if (processingTimeMs == null) return 'N/A';
    return '${processingTimeMs!.toStringAsFixed(0)}ms';
  }

  bool get isHighConfidence => confidence > 0.8;

  @override
  List<Object?> get props => [
    text,
    emotion,
    sentiment,
    confidence,
    allEmotions,
    processingTimeMs,
    category,
  ];
}
