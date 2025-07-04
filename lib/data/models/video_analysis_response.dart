class VideoAnalysisResponse {
  final int framesAnalyzed;
  final String dominantEmotion;
  final double averageConfidence;
  final SummarySnapshot summarySnapshot;

  VideoAnalysisResponse({
    required this.framesAnalyzed,
    required this.dominantEmotion,
    required this.averageConfidence,
    required this.summarySnapshot,
  });

  factory VideoAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return VideoAnalysisResponse(
      framesAnalyzed: json['frames_analyzed'],
      dominantEmotion: json['dominant_emotion'],
      averageConfidence: json['average_confidence'].toDouble(),
      summarySnapshot: SummarySnapshot.fromJson(json['summary_snapshot']),
    );
  }
}

class SummarySnapshot {
  final String emotion;
  final String sentiment;
  final double confidence;
  final String subtitle;
  final String frameImageBase64;
  final String? assetImagePath; // New field for asset images
  final int totalFramesAnalyzed;
  final Map<String, int> emotionDistribution;

  SummarySnapshot({
    required this.emotion,
    required this.sentiment,
    required this.confidence,
    required this.subtitle,
    required this.frameImageBase64,
    this.assetImagePath, // Optional asset path
    required this.totalFramesAnalyzed,
    required this.emotionDistribution,
  });

  factory SummarySnapshot.fromJson(Map<String, dynamic> json) {
    return SummarySnapshot(
      emotion: json['emotion'],
      sentiment: json['sentiment'],
      confidence: json['confidence'].toDouble(),
      subtitle: json['subtitle'],
      frameImageBase64: json['frame_image_base64'],
      assetImagePath: json['asset_image_path'], // Optional field
      totalFramesAnalyzed: json['total_frames_analyzed'],
      emotionDistribution: Map<String, int>.from(json['emotion_distribution']),
    );
  }
}
