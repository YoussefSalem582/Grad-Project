import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/video_analysis_response.dart';
import '../../../data/repositories/video_analysis_repository.dart';

part 'video_analysis_state.dart';

class VideoAnalysisCubit extends Cubit<VideoAnalysisState> {
  final VideoAnalysisRepository _repository;

  VideoAnalysisCubit(this._repository) : super(const VideoAnalysisInitial());

  /// Analyze video from URL
  Future<void> analyzeVideo({
    required String videoUrl,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    if (videoUrl.trim().isEmpty) {
      emit(const VideoAnalysisError('Video URL cannot be empty'));
      return;
    }

    emit(const VideoAnalysisLoading());

    try {
      final result = await _repository.analyzeVideo(
        videoUrl: videoUrl,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );

      emit(VideoAnalysisSuccess(result));
    } catch (e) {
      // If backend fails, show demo data with asset images
      emit(VideoAnalysisDemo(_createDemoResult(videoUrl)));
    }
  }

  /// Load demo data for testing
  void loadDemoData([String? videoUrl]) {
    emit(VideoAnalysisDemo(_createDemoResult(videoUrl)));
  }

  /// Reset to initial state
  void reset() {
    emit(const VideoAnalysisInitial());
  }

  /// Create demo result for testing
  VideoAnalysisResponse _createDemoResult([String? videoUrl]) {
    final demoResults = _createMultipleDemoResults();

    // Choose result based on URL content or alternate
    if (videoUrl != null) {
      if (videoUrl.contains('happy') ||
          videoUrl.contains('positive') ||
          videoUrl.contains('review1')) {
        return demoResults[0]; // Happy customer review
      } else if (videoUrl.contains('neutral') ||
          videoUrl.contains('mixed') ||
          videoUrl.contains('review2')) {
        return demoResults[1]; // Neutral/mixed review
      }
    }

    // Default to alternating or random selection
    final now = DateTime.now();
    return demoResults[now.second % 2]; // Alternates based on current second
  }

  /// Create multiple demo results using asset images
  List<VideoAnalysisResponse> _createMultipleDemoResults() {
    return [
      // Product Review 1 - Happy Customer
      VideoAnalysisResponse(
        framesAnalyzed: 8,
        dominantEmotion: 'Happy',
        averageConfidence: 0.92,
        summarySnapshot: SummarySnapshot(
          emotion: 'Happy',
          sentiment: 'positive',
          confidence: 0.92,
          subtitle:
              'Customer expresses genuine satisfaction with the product. Shows excitement about features and recommends to others. Overall very positive product review experience.',
          frameImageBase64: '', // Empty since we're using asset
          assetImagePath: 'assets/images/product_review_1.png',
          totalFramesAnalyzed: 8,
          emotionDistribution: {
            'Happy': 5,
            'Excited': 2,
            'Confident': 1,
            'Neutral': 0,
          },
        ),
      ),

      // Product Review 2 - Mixed Emotions
      VideoAnalysisResponse(
        framesAnalyzed: 6,
        dominantEmotion: 'Neutral',
        averageConfidence: 0.84,
        summarySnapshot: SummarySnapshot(
          emotion: 'Neutral',
          sentiment: 'neutral',
          confidence: 0.84,
          subtitle:
              'Customer provides balanced feedback about the product. Shows some concerns but also highlights positive aspects. Thoughtful and analytical review approach.',
          frameImageBase64: '', // Empty since we're using asset
          assetImagePath: 'assets/images/product_review_2.png',
          totalFramesAnalyzed: 6,
          emotionDistribution: {
            'Neutral': 3,
            'Serious': 2,
            'Happy': 1,
            'Concerned': 0,
          },
        ),
      ),
    ];
  }
}
