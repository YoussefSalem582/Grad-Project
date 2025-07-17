import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/video_analysis_response.dart';
import '../../../data/repositories/video_analysis_repository.dart';

part 'video_analysis_state.dart';

class VideoAnalysisCubit extends Cubit<VideoAnalysisState> {
  final VideoAnalysisRepository _repository;

  VideoAnalysisCubit(this._repository) : super(const VideoAnalysisInitial());

  /// Analyze video from URL with enhanced snapshot processing
  Future<void> analyzeVideo({
    required String videoUrl,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    print('Current VideoAnalysisState: ${state.toString()}');

    if (videoUrl.trim().isEmpty) {
      emit(const VideoAnalysisError('Video URL cannot be empty'));
      return;
    }

    print('Analyzing video URL: $videoUrl');
    emit(const VideoAnalysisLoading());
    print('Current VideoAnalysisState: ${state.toString()}');

    try {
      // Add realistic processing delay (8-12 seconds for thorough analysis)
      await Future.delayed(const Duration(seconds: 10));

      final result = await _repository.analyzeVideo(
        videoUrl: videoUrl,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );

      emit(VideoAnalysisSuccess(result));
      print('Current VideoAnalysisState: ${state.toString()}');
    } catch (e) {
      print('Analysis failed, falling back to demo data: $e');

      // Add additional delay for demo processing
      await Future.delayed(const Duration(seconds: 1));

      // If backend fails, show demo data with asset images
      final demoResult = _createDemoResult(videoUrl);
      emit(VideoAnalysisDemo(demoResult));
      print('Current VideoAnalysisState: ${state.toString()}');
    }
  }

  /// Analyze video from uploaded file with enhanced snapshot capture
  Future<void> analyzeVideoFile({
    required File videoFile,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    print('Current VideoAnalysisState: ${state.toString()}');
    print('Analyzing video file: ${videoFile.path}');

    emit(const VideoAnalysisLoading());
    print('Current VideoAnalysisState: ${state.toString()}');

    try {
      // Add realistic file processing delay (10-15 seconds for larger video files)
      await Future.delayed(const Duration(seconds: 12));

      final result = await _repository.analyzeVideoFile(
        videoFile: videoFile,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );

      emit(VideoAnalysisSuccess(result));
      print('Current VideoAnalysisState: ${state.toString()}');
    } catch (e) {
      print('File analysis failed, falling back to demo data: $e');

      // Add additional delay for demo file processing
      await Future.delayed(const Duration(seconds: 1));

      // If backend fails, show demo data with file name
      final demoResult = _createDemoResult(videoFile.path);
      emit(VideoAnalysisDemo(demoResult));
      print('Current VideoAnalysisState: ${state.toString()}');
    }
  }

  /// Load demo data for testing
  Future<void> loadDemoData([String? videoUrl]) async {
    emit(const VideoAnalysisLoading());

    // Add realistic demo processing delay (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    emit(VideoAnalysisDemo(_createDemoResult(videoUrl)));
  }

  /// Reset to initial state
  void reset() {
    emit(const VideoAnalysisInitial());
  }

  /// Create demo result for testing
  VideoAnalysisResponse _createDemoResult([String? videoUrl]) {
    print('Creating demo result for videoUrl: $videoUrl');
    final demoResults = _createMultipleDemoResults();

    // Choose result based on URL content or alternate
    if (videoUrl != null) {
      if (videoUrl.contains('happy') ||
          videoUrl.contains('positive') ||
          videoUrl.contains('review1')) {
        print('Using happy customer review result');
        return demoResults[0]; // Happy customer review
      } else if (videoUrl.contains('neutral') ||
          videoUrl.contains('mixed') ||
          videoUrl.contains('review2')) {
        print('Using neutral/mixed review result');
        return demoResults[1]; // Neutral/mixed review
      }
    }

    // Default to alternating or random selection
    final now = DateTime.now();
    final selectedIndex = now.second % 2;
    print('Using default result at index: $selectedIndex');
    return demoResults[selectedIndex]; // Alternates based on current second
  }

  /// Create multiple demo results using asset images
  List<VideoAnalysisResponse> _createMultipleDemoResults() {
    print('Creating multiple demo results with asset images');
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
              'Linus tests an all‑Logitech gaming desk and ends up impressed but not blown away: the G715 wireless TKL keyboard feels premium and feature‑rich, yet its high price and ABS keycaps keep it shy of “must‑buy” status, while the ultra‑light G Pro X Superlight mouse paired with the PowerPlay charging mat remains one of his favorite peripherals—flawless in performance, if you can stomach the cost and outdated micro‑USB port.',
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
