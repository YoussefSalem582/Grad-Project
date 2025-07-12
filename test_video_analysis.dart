import 'package:flutter_test/flutter_test.dart';
import 'lib/data/services/video_analysis_api_service.dart';
import 'lib/data/models/video_analysis_response.dart';

void main() {
  group('Video Analysis Service Tests', () {
    late VideoAnalysisApiService service;

    setUp(() {
      service = VideoAnalysisApiService();
    });

    test('should return mock data when backend is unavailable', () async {
      // This test will use mock data since backend is not running
      final result = await service.analyzeVideo(
        videoUrl: 'https://example.com/test-video.mp4',
        frameInterval: 30,
        maxFrames: 5,
      );

      expect(result, isA<VideoAnalysisResponse>());
      expect(result.dominantEmotion, 'happy');
      expect(result.framesAnalyzed, 5);
      expect(result.averageConfidence, 0.85);
      expect(result.summarySnapshot.emotion, 'happy');
      expect(result.summarySnapshot.sentiment, 'positive');
      expect(result.summarySnapshot.totalFramesAnalyzed, 5);
      expect(result.summarySnapshot.emotionDistribution.isNotEmpty, true);
    });

    test('should check backend connection', () async {
      final isConnected = await service.checkConnection();
      // This will be false since backend is not running
      expect(isConnected, false);
    });
  });
}
