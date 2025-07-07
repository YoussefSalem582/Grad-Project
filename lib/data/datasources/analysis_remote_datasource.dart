import 'package:dio/dio.dart';
import '../models/analysis_result_model.dart';
import '../../domain/entities/analysis_result.dart';
import '../../core/network/api_client.dart';
import '../../core/errors/api_exception.dart';

/// Remote data source for analysis operations
abstract class AnalysisRemoteDataSource {
  Future<AnalysisResultModel> analyzeText(String content);
  Future<AnalysisResultModel> analyzeVoice(String audioPath);
  Future<AnalysisResultModel> analyzeVideo(String videoPath);
  Future<AnalysisResultModel> analyzeSocial(String url);
  Future<List<AnalysisResultModel>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  });
  Future<void> deleteAnalysis(String id);
  Future<AnalysisResultModel?> getAnalysisById(String id);
}

/// Real implementation connecting to EmoSense Render backend
class AnalysisRemoteDataSourceImpl implements AnalysisRemoteDataSource {
  final ApiClient _apiClient;

  AnalysisRemoteDataSourceImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  Future<AnalysisResultModel> analyzeText(String content) async {
    try {
      final response = await _apiClient.post(
        '/analyze/text',
        data: {'text': content},
      );

      if (response.data['success'] == true) {
        final analysisData = response.data['data'];
        return _mapBackendResponseToModel(analysisData, 'text', content);
      } else {
        throw ApiException(
          message: response.data['error'] ?? 'Text analysis failed',
          statusCode: response.statusCode ?? 500,
          type: ApiExceptionType.server,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to analyze text: ${e.toString()}',
        statusCode: 500,
        type: ApiExceptionType.unknown,
      );
    }
  }

  @override
  Future<AnalysisResultModel> analyzeVoice(String audioPath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(audioPath),
      });

      final response = await _apiClient.post('/analyze/audio', data: formData);

      if (response.data['success'] == true) {
        final analysisData = response.data['data'];
        return _mapBackendResponseToModel(
          analysisData,
          'voice',
          'Audio analysis',
        );
      } else {
        throw ApiException(
          message: response.data['error'] ?? 'Voice analysis failed',
          statusCode: response.statusCode ?? 500,
          type: ApiExceptionType.server,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to analyze voice: ${e.toString()}',
        statusCode: 500,
        type: ApiExceptionType.unknown,
      );
    }
  }

  @override
  Future<AnalysisResultModel> analyzeVideo(String videoPath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(videoPath),
      });

      final response = await _apiClient.post('/analyze/video', data: formData);

      if (response.data['success'] == true) {
        final analysisData = response.data['data'];
        return _mapBackendResponseToModel(
          analysisData,
          'video',
          'Video analysis',
        );
      } else {
        throw ApiException(
          message: response.data['error'] ?? 'Video analysis failed',
          statusCode: response.statusCode ?? 500,
          type: ApiExceptionType.server,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to analyze video: ${e.toString()}',
        statusCode: 500,
        type: ApiExceptionType.unknown,
      );
    }
  }

  @override
  Future<AnalysisResultModel> analyzeSocial(String url) async {
    // For now, extract text from social URL and analyze as text
    // Could be enhanced to actually scrape social media content
    return analyzeText('Social media content from: $url');
  }

  /// Map backend response to our model format
  AnalysisResultModel _mapBackendResponseToModel(
    Map<String, dynamic> data,
    String type,
    String content,
  ) {
    // Backend response format:
    // {
    //   "emotion": "joy",
    //   "confidence": 0.95,
    //   "emotions": {"joy": 0.95, "sadness": 0.02, ...},
    //   "processing_time": 0.123,
    //   "model_used": "transformers-cpu"
    // }

    final primaryEmotion = data['emotion'] ?? 'neutral';
    final confidence = (data['confidence'] ?? 0.0).toDouble();
    final emotions = data['emotions'] as Map<String, dynamic>? ?? {};

    // Convert emotions map to our emotion score models
    final emotionScores =
        emotions.entries
            .map(
              (entry) => EmotionScoreModel(
                emotion: entry.key,
                score: (entry.value as num).toDouble(),
              ),
            )
            .toList();

    // Determine sentiment from primary emotion
    final sentiment = _emotionToSentiment(primaryEmotion);

    // Extract keywords from content (simple implementation)
    final keywords = _extractKeywords(content);

    return AnalysisResultModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
      sentiment: SentimentScoreModel(type: sentiment, score: confidence),
      confidence: confidence,
      keywords: keywords,
      emotions: emotionScores,
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  /// Convert emotion to sentiment type
  String _emotionToSentiment(String emotion) {
    const positiveEmotions = [
      'joy',
      'happiness',
      'excited',
      'love',
      'surprise',
    ];
    const negativeEmotions = ['sadness', 'anger', 'fear', 'disgust'];

    if (positiveEmotions.contains(emotion.toLowerCase())) {
      return 'positive';
    } else if (negativeEmotions.contains(emotion.toLowerCase())) {
      return 'negative';
    } else {
      return 'neutral';
    }
  }

  /// Simple keyword extraction
  List<String> _extractKeywords(String content) {
    final words = content.toLowerCase().split(RegExp(r'\W+'));
    final stopWords = {
      'the',
      'is',
      'are',
      'and',
      'or',
      'but',
      'in',
      'on',
      'at',
      'to',
      'for',
      'of',
      'with',
      'by',
      'a',
      'an',
    };

    return words
        .where((word) => word.length > 3 && !stopWords.contains(word))
        .take(5)
        .toList();
  }

  @override
  Future<List<AnalysisResultModel>> getAnalysisHistory({
    AnalysisType? type,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (type != null) {
        queryParams['type'] = type.toString().split('.').last;
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _apiClient.get(
        '/analyze/history',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true) {
        final List<dynamic> historyData = response.data['data'] ?? [];
        return historyData
            .map(
              (item) => _mapBackendResponseToModel(
                item as Map<String, dynamic>,
                item['type'] ?? 'text',
                item['content'] ?? 'Historical analysis',
              ),
            )
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      // Return empty list on error instead of throwing
      return [];
    }
  }

  @override
  Future<void> deleteAnalysis(String id) async {
    try {
      await _apiClient.delete('/analyze/$id');
    } catch (e) {
      throw ApiException(
        message: 'Failed to delete analysis: ${e.toString()}',
        statusCode: 500,
        type: ApiExceptionType.unknown,
      );
    }
  }

  @override
  Future<AnalysisResultModel?> getAnalysisById(String id) async {
    try {
      final response = await _apiClient.get('/analyze/$id');

      if (response.data['success'] == true) {
        final analysisData = response.data['data'];
        return _mapBackendResponseToModel(
          analysisData,
          analysisData['type'] ?? 'text',
          analysisData['content'] ?? 'Analysis result',
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
