import '../models/analysis_result_model.dart';
import '../../domain/entities/analysis_result.dart';

/// Remote data source for analysis operations
abstract class AnalysisRemoteDataSource {
  Future<AnalysisResultModel> analyzeText(String content);
  Future<AnalysisResultModel> analyzeVoice(String audioPath);
  Future<AnalysisResultModel> analyzeSocial(String url);
  Future<List<AnalysisResultModel>> getAnalysisHistory();
  Future<void> deleteAnalysis(String id);
  Future<AnalysisResultModel?> getAnalysisById(String id);
}

/// Implementation of remote data source
class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  @override
  Future<AnalysisResultModel> analyzeText(String content) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return AnalysisResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      content: content,
      primaryEmotion: Emotion.happy,
      sentiment: 0.8,
      emotionScores: {
        Emotion.happy: 0.7,
        Emotion.neutral: 0.2,
        Emotion.sad: 0.1,
      },
    );
  }

  @override
  Future<AnalysisResultModel> analyzeVoice(String audioPath) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    return AnalysisResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      content: 'Voice analysis completed',
      primaryEmotion: Emotion.neutral,
      sentiment: 0.6,
      emotionScores: {Emotion.neutral: 0.8, Emotion.happy: 0.2},
      audioUrl: audioPath,
    );
  }

  @override
  Future<AnalysisResultModel> analyzeSocial(String url) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return AnalysisResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      content: 'Social media analysis completed',
      primaryEmotion: Emotion.happy,
      sentiment: 0.9,
      emotionScores: {Emotion.happy: 0.6, Emotion.surprised: 0.4},
      socialMediaUrl: url,
    );
  }

  @override
  Future<List<AnalysisResultModel>> getAnalysisHistory() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return [];
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<AnalysisResultModel?> getAnalysisById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }

  String? _extractPlatform(String url) {
    if (url.contains('twitter.com') || url.contains('x.com')) return 'Twitter';
    if (url.contains('facebook.com')) return 'Facebook';
    if (url.contains('instagram.com')) return 'Instagram';
    if (url.contains('linkedin.com')) return 'LinkedIn';
    return 'Unknown';
  }
}
