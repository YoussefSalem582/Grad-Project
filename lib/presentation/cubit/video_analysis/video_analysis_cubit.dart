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
      // If backend fails, show demo data
      emit(VideoAnalysisDemo(_createDemoResult()));
    }
  }

  /// Load demo data for testing
  void loadDemoData() {
    emit(VideoAnalysisDemo(_createDemoResult()));
  }

  /// Reset to initial state
  void reset() {
    emit(const VideoAnalysisInitial());
  }

  /// Create demo result for testing
  VideoAnalysisResponse _createDemoResult() {
    return VideoAnalysisResponse(
      framesAnalyzed: 5,
      dominantEmotion: 'Happy',
      averageConfidence: 0.89,
      summarySnapshot: SummarySnapshot(
        emotion: 'Happy',
        sentiment: 'positive',
        confidence: 0.89,
        subtitle: 'A comprehensive video analysis showing positive emotions and high customer satisfaction throughout the content.',
        frameImageBase64: _generateDemoImageBase64(),
        totalFramesAnalyzed: 5,
        emotionDistribution: {
          'Happy': 3,
          'Excited': 1,
          'Confident': 1,
          'Neutral': 0,
        },
      ),
    );
  }

  /// Generate a simple demo image (1x1 transparent pixel)
  String _generateDemoImageBase64() {
    return 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
  }
}
