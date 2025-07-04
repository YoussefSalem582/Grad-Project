import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/video_analysis_response.dart';

class VideoAnalysisApiService {
  static const String _baseUrl = 'http://localhost:8002';
  static const String _videoAnalysisEndpoint = '/analyze-video';
  static const String _healthEndpoint = '/health';

  final http.Client _client;

  VideoAnalysisApiService({http.Client? client})
    : _client = client ?? http.Client();

  /// Analyze video from URL
  Future<VideoAnalysisResponse> analyzeVideo({
    required String videoUrl,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    try {
      final requestBody = {
        'video_url': videoUrl,
        'frame_interval': frameInterval,
        'max_frames': maxFrames,
      };

      final response = await _client
          .post(
            Uri.parse('$_baseUrl$_videoAnalysisEndpoint'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return _parseVideoAnalysisResponse(responseData);
      } else {
        throw Exception('Server responded with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Check backend connection
  Future<bool> checkConnection() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl$_healthEndpoint'))
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Get connection details
  Future<Map<String, dynamic>> getConnectionDetails() async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl$_healthEndpoint'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'status': 'connected',
          'url': _baseUrl,
          'statusCode': response.statusCode,
          'timestamp': DateTime.now().toIso8601String(),
          'responseTime': 'Good',
          'version': data['version'] ?? 'Unknown',
          'server': data['server'] ?? 'Unknown',
        };
      } else {
        return {
          'status': 'error',
          'statusCode': response.statusCode,
          'error': 'Server responded with ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'status': 'disconnected',
        'error': e.toString(),
        'url': _baseUrl,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Parse the video analysis response from backend
  VideoAnalysisResponse _parseVideoAnalysisResponse(Map<String, dynamic> data) {
    // Parse the backend response format
    final summary = data['summary'] as Map<String, dynamic>;
    final analysisResults = data['analysis_results'] as List;

    // Create summary snapshot from the first frame and summary data
    final firstFrame = analysisResults.isNotEmpty
        ? analysisResults.first as Map<String, dynamic>
        : null;

    final summarySnapshot = SummarySnapshot(
      emotion: summary['dominant_emotion'] ?? 'neutral',
      sentiment: summary['overall_sentiment'] ?? 'neutral',
      confidence: (summary['confidence'] ?? 0.0).toDouble(),
      subtitle: _generateSummaryText(summary, analysisResults),
      frameImageBase64: _generateSummaryImage(),
      totalFramesAnalyzed: summary['total_frames_analyzed'] ?? 0,
      emotionDistribution: Map<String, int>.from(
        summary['emotion_distribution'] ?? {},
      ),
    );

    return VideoAnalysisResponse(
      framesAnalyzed: summary['total_frames_analyzed'] ?? 0,
      dominantEmotion: summary['dominant_emotion'] ?? 'neutral',
      averageConfidence: (summary['confidence'] ?? 0.0).toDouble(),
      summarySnapshot: summarySnapshot,
    );
  }

  /// Generate summary text based on analysis results
  String _generateSummaryText(
    Map<String, dynamic> summary,
    List analysisResults,
  ) {
    final dominantEmotion = summary['dominant_emotion'] ?? 'neutral';
    final sentiment = summary['overall_sentiment'] ?? 'neutral';
    final confidence = summary['confidence'] ?? 0.0;
    final framesCount = summary['total_frames_analyzed'] ?? 0;

    return 'Video analysis of $framesCount frames shows predominantly $dominantEmotion emotion with $sentiment sentiment. '
        'Analysis confidence: ${(confidence * 100).toInt()}%. '
        'This indicates a ${sentiment == 'positive'
            ? 'favorable'
            : sentiment == 'negative'
            ? 'concerning'
            : 'balanced'} emotional tone throughout the content.';
  }

  /// Generate a placeholder image for summary
  String _generateSummaryImage() {
    // Return a 1x1 transparent pixel as placeholder
    return 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
  }

  /// Dispose of resources
  void dispose() {
    _client.close();
  }
}
