import '../models/analysis_result_model.dart';
import '../../domain/entities/analysis_result.dart';

/// Remote data source for analysis operations
abstract class AnalysisRemoteDataSource {
  Future<AnalysisResultModel> analyzeText(String content);
  Future<AnalysisResultModel> analyzeVoice(String audioPath);
  Future<AnalysisResultModel> analyzeSocial(String url);
  Future<List<AnalysisResultModel>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  });
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
      content: content,
      type: 'text',
      sentiment: SentimentScoreModel(type: 'positive', score: 0.8),
      confidence: 0.85,
      keywords: ['customer', 'service', 'quality'],
      emotions: [
        EmotionScoreModel(emotion: 'happy', score: 0.7),
        EmotionScoreModel(emotion: 'calm', score: 0.3),
      ],
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<AnalysisResultModel> analyzeVoice(String audioPath) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 3));

    return AnalysisResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Voice analysis completed',
      type: 'voice',
      sentiment: SentimentScoreModel(type: 'neutral', score: 0.6),
      confidence: 0.78,
      keywords: ['voice', 'quality', 'clear'],
      emotions: [
        EmotionScoreModel(emotion: 'calm', score: 0.8),
        EmotionScoreModel(emotion: 'happy', score: 0.2),
      ],
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<AnalysisResultModel> analyzeSocial(String url) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return AnalysisResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: 'Social media analysis completed',
      type: 'social',
      sentiment: SentimentScoreModel(type: 'positive', score: 0.9),
      confidence: 0.92,
      keywords: ['social', 'media', 'positive'],
      emotions: [
        EmotionScoreModel(emotion: 'excited', score: 0.6),
        EmotionScoreModel(emotion: 'happy', score: 0.4),
      ],
      createdAt: DateTime.now().toIso8601String(),
      platform: _extractPlatform(url),
    );
  }

  @override
  Future<List<AnalysisResultModel>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  }) async {
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
