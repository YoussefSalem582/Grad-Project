import 'package:equatable/equatable.dart';

class AnalyticsSummary extends Equatable {
  final int totalAnalyses;
  final Map<String, int> emotionCounts;
  final Map<String, int> sentimentCounts;
  final double averageConfidence;
  final List<PopularText> popularTexts;
  final PerformanceStats performanceStats;
  final TimeRange timeRange;
  final String lastUpdated;

  const AnalyticsSummary({
    required this.totalAnalyses,
    required this.emotionCounts,
    required this.sentimentCounts,
    required this.averageConfidence,
    required this.popularTexts,
    required this.performanceStats,
    required this.timeRange,
    required this.lastUpdated,
  });

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      totalAnalyses: json['total_analyses'] as int? ?? 0,
      emotionCounts: Map<String, int>.from(
        json['emotion_counts'] as Map? ?? {},
      ),
      sentimentCounts: Map<String, int>.from(
        json['sentiment_counts'] as Map? ?? {},
      ),
      averageConfidence:
          (json['average_confidence'] as num?)?.toDouble() ?? 0.0,
      popularTexts:
          (json['popular_texts'] as List?)
              ?.map(
                (item) => PopularText.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      performanceStats: PerformanceStats.fromJson(
        json['performance_stats'] as Map<String, dynamic>? ?? {},
      ),
      timeRange: TimeRange.fromJson(
        json['time_range'] as Map<String, dynamic>? ?? {},
      ),
      lastUpdated:
          json['last_updated'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_analyses': totalAnalyses,
      'emotion_counts': emotionCounts,
      'sentiment_counts': sentimentCounts,
      'average_confidence': averageConfidence,
      'popular_texts': popularTexts.map((text) => text.toJson()).toList(),
      'performance_stats': performanceStats.toJson(),
      'time_range': timeRange.toJson(),
      'last_updated': lastUpdated,
    };
  }

  String get topEmotion {
    if (emotionCounts.isEmpty) return 'None';
    return emotionCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String get topSentiment {
    if (sentimentCounts.isEmpty) return 'None';
    return sentimentCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  String get averageConfidenceFormatted {
    return '${(averageConfidence * 100).toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [
    totalAnalyses,
    emotionCounts,
    sentimentCounts,
    averageConfidence,
    popularTexts,
    performanceStats,
    timeRange,
    lastUpdated,
  ];
}

class PopularText extends Equatable {
  final String text;
  final String emotion;
  final String sentiment;
  final double confidence;
  final int count;

  const PopularText({
    required this.text,
    required this.emotion,
    required this.sentiment,
    required this.confidence,
    required this.count,
  });

  factory PopularText.fromJson(Map<String, dynamic> json) {
    return PopularText(
      text: json['text'] as String? ?? '',
      emotion: json['emotion'] as String? ?? '',
      sentiment: json['sentiment'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'emotion': emotion,
      'sentiment': sentiment,
      'confidence': confidence,
      'count': count,
    };
  }

  String get confidenceFormatted {
    return '${(confidence * 100).toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [text, emotion, sentiment, confidence, count];
}

class PerformanceStats extends Equatable {
  final double averageProcessingTime;
  final double minProcessingTime;
  final double maxProcessingTime;
  final int totalRequests;
  final int successfulRequests;
  final double successRate;

  const PerformanceStats({
    required this.averageProcessingTime,
    required this.minProcessingTime,
    required this.maxProcessingTime,
    required this.totalRequests,
    required this.successfulRequests,
    required this.successRate,
  });

  factory PerformanceStats.fromJson(Map<String, dynamic> json) {
    return PerformanceStats(
      averageProcessingTime:
          (json['average_processing_time'] as num?)?.toDouble() ?? 0.0,
      minProcessingTime:
          (json['min_processing_time'] as num?)?.toDouble() ?? 0.0,
      maxProcessingTime:
          (json['max_processing_time'] as num?)?.toDouble() ?? 0.0,
      totalRequests: json['total_requests'] as int? ?? 0,
      successfulRequests: json['successful_requests'] as int? ?? 0,
      successRate: (json['success_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_processing_time': averageProcessingTime,
      'min_processing_time': minProcessingTime,
      'max_processing_time': maxProcessingTime,
      'total_requests': totalRequests,
      'successful_requests': successfulRequests,
      'success_rate': successRate,
    };
  }

  String get averageProcessingTimeFormatted {
    return '${averageProcessingTime.toStringAsFixed(0)}ms';
  }

  String get successRateFormatted {
    return '${(successRate * 100).toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [
    averageProcessingTime,
    minProcessingTime,
    maxProcessingTime,
    totalRequests,
    successfulRequests,
    successRate,
  ];
}

class TimeRange extends Equatable {
  final String start;
  final String end;
  final String duration;

  const TimeRange({
    required this.start,
    required this.end,
    required this.duration,
  });

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'end': end, 'duration': duration};
  }

  @override
  List<Object?> get props => [start, end, duration];
}
