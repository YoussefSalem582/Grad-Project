import 'dart:async';
import '../../core/network/api_client.dart';
import '../../core/config/app_config.dart';
import '../../core/errors/api_exception.dart';
import '../models/emotion_result.dart';
import '../models/video_analysis_request.dart';

/// Modern emotion API service using the new API client infrastructure
///
/// This service provides a comprehensive interface for emotion analysis operations
/// including text, audio, and video analysis. It integrates with the backend
/// connection system to support multiple environments (development, staging, production)
/// and includes robust error handling and mock data support for offline development.
///
/// Key Features:
/// - Multi-modal emotion analysis (text, audio, video)
/// - Backend environment switching
/// - Mock data support for offline development
/// - Comprehensive error handling with structured exceptions
/// - Health checks and system monitoring
/// - Analytics and metrics collection
/// - Batch processing capabilities
/// - Cache management
///
/// Usage:
/// ```dart
/// final service = EmotionApiServiceV2();
///
/// // Health check
/// final health = await service.checkConnection();
///
/// // Text analysis
/// final result = await service.analyzeText('I am happy today!');
///
/// // Video analysis
/// final videoResult = await service.analyzeVideo(request);
/// ```
class EmotionApiServiceV2 {
  /// The API client instance used for making HTTP requests
  /// Injected via constructor for testability and flexibility
  final ApiClient _apiClient;

  // Backend API endpoint definitions
  // These endpoints correspond to the emotion analysis backend API
  static const String _healthEndpoint = '/health'; // Health check endpoint
  static const String _predictEndpoint =
      '/predict'; // Single emotion prediction
  static const String _metricsEndpoint = '/metrics'; // System metrics
  static const String _analyticsEndpoint = '/analytics'; // Analytics data
  static const String _modelInfoEndpoint = '/model-info'; // Model information
  static const String _batchEndpoint = '/batch-predict'; // Batch predictions
  static const String _videoAnalysisEndpoint =
      '/analyze-video'; // Video analysis
  static const String _demoEndpoint = '/demo'; // Demo functionality
  static const String _cacheStatsEndpoint = '/cache-stats'; // Cache statistics
  static const String _clearCacheEndpoint = '/clear-cache'; // Cache clearing
  static const String _testAllEndpoint = '/test-all'; // Endpoint testing

  /// Constructor with optional API client injection
  ///
  /// If no API client is provided, a default singleton instance is used.
  /// This pattern allows for easy testing with mock clients while maintaining
  /// a simple interface for production code.
  ///
  /// Parameters:
  /// - [apiClient]: Optional API client instance for dependency injection
  EmotionApiServiceV2({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  /// Health check endpoint - verifies backend connectivity and status
  ///
  /// This method performs a basic health check to determine if the backend
  /// is accessible and responding correctly. It's useful for:
  /// - Initial connection verification
  /// - Periodic health monitoring
  /// - Backend environment validation
  ///
  /// When mock data is enabled via [AppConfig.enableMockData], returns
  /// simulated health data for offline development and testing.
  ///
  /// Returns a Map containing:
  /// - status: 'healthy' or 'error'
  /// - message: Human-readable status message
  /// - version: Backend version (if available)
  /// - timestamp: ISO8601 formatted timestamp
  /// - mock: Boolean indicating if this is mock data
  ///
  /// Example usage:
  /// ```dart
  /// final health = await service.checkConnection();
  /// if (health['status'] == 'healthy') {
  ///   print('Backend is responding: ${health['message']}');
  /// }
  /// ```
  Future<Map<String, dynamic>> checkConnection() async {
    if (AppConfig.enableMockData) {
      // Return mock data for demonstration
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'status': 'healthy',
        'message': 'Mock backend is running',
        'version': '3.0.0',
        'timestamp': DateTime.now().toIso8601String(),
        'mock': true,
      };
    }

    try {
      final response = await _apiClient.get(_healthEndpoint);
      return {
        'status': 'healthy',
        'message': 'Backend is responding',
        'data': response.data,
        'statusCode': response.statusCode,
        'timestamp': DateTime.now().toIso8601String(),
        'mock': false,
      };
    } on ApiException catch (e) {
      return {
        'status': 'error',
        'message': e.message,
        'statusCode': e.statusCode,
        'type': e.type.name,
        'timestamp': DateTime.now().toIso8601String(),
        'mock': false,
      };
    }
  }

  /// Analyze emotion from text input
  ///
  /// This method performs emotion analysis on provided text using natural
  /// language processing. It's the core functionality for text-based emotion
  /// detection and supports multiple languages depending on the backend model.
  ///
  /// The analysis returns a structured result containing:
  /// - Primary detected emotion
  /// - Confidence scores for all emotion categories
  /// - Processing metadata and timing information
  ///
  /// Parameters:
  /// - [text]: The text content to analyze for emotional content
  ///
  /// Returns: [EmotionResult] object containing analysis results
  ///
  /// Throws: [Exception] if the analysis fails or the backend is unreachable
  ///
  /// Example:
  /// ```dart
  /// final result = await service.analyzeText('I am really excited about this!');
  /// print('Primary emotion: ${result.primaryEmotion}');
  /// print('Confidence: ${result.confidence}');
  /// ```
  Future<EmotionResult> analyzeText(String text) async {
    if (AppConfig.enableMockData) {
      return _generateMockEmotionResult(text);
    }

    try {
      final response = await _apiClient.post(
        _predictEndpoint,
        data: {'text': text, 'type': 'text'},
      );

      return EmotionResult.fromJson(response.data);
    } on ApiException catch (e) {
      throw Exception('Failed to analyze text: ${e.message}');
    }
  }

  /// Analyze emotion from audio file
  ///
  /// Performs emotion analysis on audio content using voice analysis models.
  /// This method processes audio files to detect emotional states based on
  /// vocal characteristics, tone, and other acoustic features.
  ///
  /// Note: In a production implementation, this would handle file uploads
  /// and streaming audio data. The current implementation sends the file path
  /// to the backend for processing.
  ///
  /// Parameters:
  /// - [audioPath]: Path to the audio file to analyze
  ///
  /// Returns: [EmotionResult] containing the analysis results
  ///
  /// Throws: [Exception] if audio processing fails
  Future<EmotionResult> analyzeAudio(String audioPath) async {
    if (AppConfig.enableMockData) {
      return _generateMockEmotionResult('Audio analysis');
    }

    try {
      // Note: In a real implementation, you'd handle file uploads differently
      final response = await _apiClient.post(
        _predictEndpoint,
        data: {'audio_path': audioPath, 'type': 'audio'},
      );

      return EmotionResult.fromJson(response.data);
    } on ApiException catch (e) {
      throw Exception('Failed to analyze audio: ${e.message}');
    }
  }

  /// Get system metrics
  Future<Map<String, dynamic>> getSystemMetrics() async {
    if (AppConfig.enableMockData) {
      return _generateMockSystemMetricsMap();
    }

    try {
      final response = await _apiClient.get(_metricsEndpoint);
      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to get system metrics: ${e.message}');
    }
  }

  /// Get analytics summary
  Future<Map<String, dynamic>> getAnalyticsSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (AppConfig.enableMockData) {
      return _generateMockAnalyticsSummaryMap();
    }

    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String();
      }

      final response = await _apiClient.get(
        _analyticsEndpoint,
        queryParameters: queryParams,
      );

      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to get analytics summary: ${e.message}');
    }
  }

  /// Analyze video for emotion detection
  Future<Map<String, dynamic>> analyzeVideo(
    VideoAnalysisRequest request,
  ) async {
    if (AppConfig.enableMockData) {
      return _generateMockVideoAnalysisResponseMap();
    }

    try {
      final response = await _apiClient.post(
        _videoAnalysisEndpoint,
        data: request.toJson(),
      );

      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to analyze video: ${e.message}');
    }
  }

  /// Batch emotion analysis
  Future<List<EmotionResult>> batchAnalyze(List<String> texts) async {
    if (AppConfig.enableMockData) {
      return texts.map((text) => _generateMockEmotionResult(text)).toList();
    }

    try {
      final response = await _apiClient.post(
        _batchEndpoint,
        data: {'texts': texts, 'type': 'text'},
      );

      final List<dynamic> results = response.data['results'] ?? [];
      return results.map((result) => EmotionResult.fromJson(result)).toList();
    } on ApiException catch (e) {
      throw Exception('Failed to perform batch analysis: ${e.message}');
    }
  }

  /// Get model information
  Future<Map<String, dynamic>> getModelInfo() async {
    if (AppConfig.enableMockData) {
      return {
        'model_name': 'MockEmotionModel',
        'version': '3.0.0',
        'accuracy': 0.95,
        'supported_emotions': [
          'happy',
          'sad',
          'angry',
          'fear',
          'surprise',
          'disgust',
          'neutral',
        ],
        'languages': ['en', 'es', 'fr'],
        'mock': true,
      };
    }

    try {
      final response = await _apiClient.get(_modelInfoEndpoint);
      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to get model info: ${e.message}');
    }
  }

  /// Run demo analysis
  Future<Map<String, dynamic>> runDemo() async {
    if (AppConfig.enableMockData) {
      return _generateMockDemoResultMap();
    }

    try {
      final response = await _apiClient.post(_demoEndpoint);
      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to run demo: ${e.message}');
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats() async {
    if (AppConfig.enableMockData) {
      return {
        'cache_size': 1024 * 1024 * 50, // 50MB
        'cache_hits': 1234,
        'cache_misses': 567,
        'hit_ratio': 0.685,
        'mock': true,
      };
    }

    try {
      final response = await _apiClient.get(_cacheStatsEndpoint);
      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to get cache stats: ${e.message}');
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    if (AppConfig.enableMockData) {
      await Future.delayed(const Duration(milliseconds: 300));
      return;
    }

    try {
      await _apiClient.post(_clearCacheEndpoint);
    } on ApiException catch (e) {
      throw Exception('Failed to clear cache: ${e.message}');
    }
  }

  /// Test all endpoints
  Future<Map<String, dynamic>> testAllEndpoints() async {
    if (AppConfig.enableMockData) {
      return {
        'health': true,
        'predict': true,
        'metrics': true,
        'analytics': true,
        'model_info': true,
        'demo': true,
        'cache_stats': true,
        'overall_status': 'All endpoints responding (mock)',
        'mock': true,
      };
    }

    try {
      final response = await _apiClient.get(_testAllEndpoint);
      return response.data;
    } on ApiException catch (e) {
      throw Exception('Failed to test endpoints: ${e.message}');
    }
  }

  // ========================================================================
  // Mock Data Generation Section
  // ========================================================================
  // The following methods generate realistic mock data for development
  // and testing purposes. They simulate backend responses without requiring
  // an actual backend connection, enabling offline development and testing.
  // ========================================================================

  /// Generates mock emotion analysis results for testing and development
  ///
  /// This method creates realistic emotion analysis data with randomized
  /// but plausible confidence scores and emotion distributions. The primary
  /// emotion is randomly selected, and supporting emotions are generated
  /// with appropriate confidence levels.
  ///
  /// The mock data includes:
  /// - Primary emotion selection from standard emotion categories
  /// - Realistic confidence scores (0.75-1.0 range)
  /// - Full emotion distribution with weighted probabilities
  /// - Processing time simulation
  /// - Timestamp information
  ///
  /// Parameters:
  /// - [input]: The input text used for context in the mock result
  ///
  /// Returns: A realistic [EmotionResult] object with mock data
  EmotionResult _generateMockEmotionResult(String input) {
    final emotions = [
      'happy',
      'sad',
      'angry',
      'fear',
      'surprise',
      'disgust',
      'neutral',
    ];
    final primaryEmotion =
        emotions[DateTime.now().millisecond % emotions.length];

    // Generate sentiment based on emotion
    String sentiment;
    if (primaryEmotion == 'happy' || primaryEmotion == 'surprise') {
      sentiment = 'positive';
    } else if (primaryEmotion == 'sad' ||
        primaryEmotion == 'angry' ||
        primaryEmotion == 'fear' ||
        primaryEmotion == 'disgust') {
      sentiment = 'negative';
    } else {
      sentiment = 'neutral';
    }

    return EmotionResult(
      emotion: primaryEmotion,
      sentiment: sentiment,
      confidence: 0.75 + (DateTime.now().millisecond % 25) / 100.0,
      allEmotions: {
        'happy': 0.1 + (DateTime.now().microsecond % 30) / 100.0,
        'sad': 0.1 + (DateTime.now().microsecond % 25) / 100.0,
        'angry': 0.05 + (DateTime.now().microsecond % 20) / 100.0,
        'fear': 0.05 + (DateTime.now().microsecond % 15) / 100.0,
        'surprise': 0.1 + (DateTime.now().microsecond % 20) / 100.0,
        'disgust': 0.03 + (DateTime.now().microsecond % 10) / 100.0,
        'neutral': 0.2 + (DateTime.now().microsecond % 40) / 100.0,
      },
      processingTimeMs: (100 + DateTime.now().millisecond % 200).toDouble(),
    );
  }

  /// Generates mock system metrics data as a Map
  ///
  /// Returns realistic system performance metrics including CPU usage,
  /// memory consumption, and request statistics for development testing.
  Map<String, dynamic> _generateMockSystemMetricsMap() {
    return {
      'cpu_usage': 25.5 + (DateTime.now().millisecond % 40),
      'memory_usage': 60.0 + (DateTime.now().millisecond % 30),
      'disk_usage': 45.0 + (DateTime.now().millisecond % 20),
      'requests_per_minute': 120 + DateTime.now().millisecond % 80,
      'active_connections': 15 + DateTime.now().millisecond % 10,
      'uptime': '24h 30m',
      'timestamp': DateTime.now().toIso8601String(),
      'mock': true,
    };
  }

  /// Generates mock analytics summary data as a Map
  ///
  /// Returns comprehensive analytics data including emotion distributions,
  /// sentiment analysis results, and performance statistics.
  Map<String, dynamic> _generateMockAnalyticsSummaryMap() {
    return {
      'total_analyses': 15420 + DateTime.now().day * 100,
      'emotion_distribution': {
        'happy': 0.35,
        'neutral': 0.25,
        'sad': 0.15,
        'angry': 0.10,
        'surprise': 0.08,
        'fear': 0.04,
        'disgust': 0.03,
      },
      'average_confidence': 0.82,
      'top_emotions': ['happy', 'neutral', 'sad'],
      'analysis_types': {'text': 0.60, 'audio': 0.25, 'video': 0.15},
      'time_range': {
        'start': DateTime.now()
            .subtract(const Duration(days: 30))
            .toIso8601String(),
        'end': DateTime.now().toIso8601String(),
      },
      'mock': true,
    };
  }

  /// Generates mock video analysis response data as a Map
  ///
  /// Returns realistic video emotion analysis results including segments,
  /// overall emotions, and processing metadata.
  Map<String, dynamic> _generateMockVideoAnalysisResponseMap() {
    return {
      'analysis_id': 'mock_${DateTime.now().millisecondsSinceEpoch}',
      'status': 'completed',
      'overall_emotion': 'happy',
      'confidence': 0.87,
      'segments': [
        {
          'start_time': 0.0,
          'end_time': 5.0,
          'emotion': 'happy',
          'confidence': 0.92,
        },
        {
          'start_time': 5.0,
          'end_time': 10.0,
          'emotion': 'neutral',
          'confidence': 0.78,
        },
      ],
      'processing_time': 30,
      'timestamp': DateTime.now().toIso8601String(),
      'mock': true,
    };
  }

  /// Generates mock demo result data as a Map
  ///
  /// Returns demo analysis results with sample emotion analyses
  /// and execution statistics for testing purposes.
  Map<String, dynamic> _generateMockDemoResultMap() {
    return {
      'demo_type': 'full_analysis',
      'results': [
        _generateMockEmotionResult('This is a great product!').toJson(),
        _generateMockEmotionResult(
          'I am not satisfied with the service.',
        ).toJson(),
        _generateMockEmotionResult('The experience was okay.').toJson(),
      ],
      'summary': 'Demo completed successfully with 3 sample analyses',
      'execution_time': 2,
      'timestamp': DateTime.now().toIso8601String(),
      'mock': true,
    };
  }
}

/// Backward compatibility wrapper for the emotion API service
///
/// This class extends [EmotionApiServiceV2] to maintain compatibility with
/// existing code that depends on the original [EmotionApiService] class name.
/// It provides the same functionality as the v2 service while allowing
/// gradual migration to the new implementation.
///
/// Usage:
/// ```dart
/// // Legacy usage - still works
/// final service = EmotionApiService();
///
/// // Recommended usage - direct v2 usage
/// final serviceV2 = EmotionApiServiceV2();
/// ```
///
/// Note: This wrapper will be deprecated in future versions once all
/// dependent code has been migrated to use [EmotionApiServiceV2] directly.
class EmotionApiService extends EmotionApiServiceV2 {
  /// Constructor that forwards to the parent [EmotionApiServiceV2]
  ///
  /// Parameters:
  /// - [apiClient]: Optional API client for dependency injection
  EmotionApiService({ApiClient? apiClient}) : super(apiClient: apiClient);
}
