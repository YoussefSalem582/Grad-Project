import 'dart:io';
import '../models/video_analysis_response.dart';
import '../services/video_analysis_api_service.dart';

class VideoAnalysisRepository {
  final VideoAnalysisApiService _apiService;

  VideoAnalysisRepository(this._apiService);

  /// Analyze video from URL
  Future<VideoAnalysisResponse> analyzeVideo({
    required String videoUrl,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    try {
      return await _apiService.analyzeVideo(
        videoUrl: videoUrl,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );
    } catch (e) {
      throw Exception('Failed to analyze video: ${e.toString()}');
    }
  }

  /// Analyze video from uploaded file
  Future<VideoAnalysisResponse> analyzeVideoFile({
    required File videoFile,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    try {
      return await _apiService.analyzeVideoFile(
        videoFile: videoFile,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );
    } catch (e) {
      throw Exception('Failed to analyze video file: ${e.toString()}');
    }
  }

  /// Check if the backend is available
  Future<bool> checkConnection() async {
    return await _apiService.checkConnection();
  }

  /// Get connection details
  Future<Map<String, dynamic>> getConnectionDetails() async {
    return await _apiService.getConnectionDetails();
  }
}
