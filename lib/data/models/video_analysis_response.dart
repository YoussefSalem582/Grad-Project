import 'emotion_result.dart';

class VideoAnalysisResponse {
  final int framesAnalyzed;
  final List<FrameAnalysis> frameResults;
  final String dominantEmotion;
  final double averageConfidence;

  VideoAnalysisResponse({
    required this.framesAnalyzed,
    required this.frameResults,
    required this.dominantEmotion,
    required this.averageConfidence,
  });

  factory VideoAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return VideoAnalysisResponse(
      framesAnalyzed: json['frames_analyzed'],
      frameResults: (json['frame_results'] as List)
          .map((frame) => FrameAnalysis.fromJson(frame))
          .toList(),
      dominantEmotion: json['dominant_emotion'],
      averageConfidence: json['average_confidence'].toDouble(),
    );
  }
}

class FrameAnalysis {
  final int frameNumber;
  final EmotionResult emotionResult;
  final double timestamp;

  FrameAnalysis({
    required this.frameNumber,
    required this.emotionResult,
    required this.timestamp,
  });

  factory FrameAnalysis.fromJson(Map<String, dynamic> json) {
    return FrameAnalysis(
      frameNumber: json['frame_number'],
      emotionResult: EmotionResult.fromJson(json['emotion_result']),
      timestamp: json['timestamp'].toDouble(),
    );
  }
}
