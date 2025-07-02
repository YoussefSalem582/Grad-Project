import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../data/models/emotion_result.dart';
import '../../data/models/system_metrics.dart';
import '../../data/models/analytics_summary.dart';
import '../../data/models/demo_result.dart';
import '../../data/models/video_analysis_response.dart';
import '../../data/models/video_analysis_request.dart';
import '../../data/services/emotion_api_service.dart';
import '../../core/constants/app_strings.dart';

enum EmotionState { initial, loading, success, error, connectionChecking }

class EmotionProvider extends ChangeNotifier {
  final EmotionApiService _apiService;

  // Basic State
  EmotionState _state = EmotionState.initial;
  bool _isConnected = false;
  EmotionResult? _emotionResult;
  String? _errorMessage;

  // NEW: Enhanced Features State
  SystemMetrics? _systemMetrics;
  AnalyticsSummary? _analyticsSummary;
  DemoResult? _demoResult;
  Map<String, dynamic>? _cacheStats;
  Map<String, dynamic>? _modelInfo;
  Map<String, dynamic>? _apiInfo;
  Map<String, dynamic>? _connectionDetails;
  Map<String, bool> _endpointStatus = {};

  // NEW: Batch processing
  List<EmotionResult> _batchResults = [];
  bool _isBatchProcessing = false;

  // NEW: Auto-refresh settings
  bool _autoRefreshMetrics = false;
  Timer? _metricsTimer;

  // NEW: Video Analysis State
  bool _isVideoLoading = false;
  VideoAnalysisResponse? _lastVideoResult;

  // Basic Getters
  EmotionState get state => _state;
  bool get isConnected => _isConnected;
  bool get isLoading => _state == EmotionState.loading;
  bool get isConnectionChecking => _state == EmotionState.connectionChecking;
  EmotionResult? get emotionResult => _emotionResult;
  String? get error => _errorMessage;
  bool get hasResult => _emotionResult != null;

  // NEW: Enhanced Feature Getters
  SystemMetrics? get systemMetrics => _systemMetrics;
  AnalyticsSummary? get analyticsSummary => _analyticsSummary;
  DemoResult? get demoResult => _demoResult;
  Map<String, dynamic>? get cacheStats => _cacheStats;
  Map<String, dynamic>? get modelInfo => _modelInfo;
  Map<String, dynamic>? get apiInfo => _apiInfo;
  Map<String, dynamic>? get connectionDetails => _connectionDetails;
  Map<String, bool> get endpointStatus => _endpointStatus;
  List<EmotionResult> get batchResults => _batchResults;
  bool get isBatchProcessing => _isBatchProcessing;
  bool get autoRefreshMetrics => _autoRefreshMetrics;

  // NEW: Video Analysis Getters
  bool get isVideoLoading => _isVideoLoading;
  VideoAnalysisResponse? get lastVideoResult => _lastVideoResult;

  // Constructor
  EmotionProvider(this._apiService) {
    // Don't do heavy initialization in constructor to prevent white screen
    _safeInitialize();
  }

  // Safe initialization that won't block the UI
  void _safeInitialize() {
    // Initialize connection check without blocking
    Future.microtask(() async {
      try {
        await checkConnection();
        await _initializeEnhancedFeatures();
      } catch (e) {
        // Silently handle initialization errors
        _isConnected = false;
        _state = EmotionState.initial;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _metricsTimer?.cancel();
    super.dispose();
  }

  // NEW: Initialize enhanced features
  Future<void> _initializeEnhancedFeatures() async {
    await Future.wait([
      loadDemoData(),
      loadSystemMetrics(),
      loadAnalytics(),
      loadCacheStats(),
      loadModelInfo(),
    ]);
  }

  // Enhanced connection check
  Future<void> checkConnection() async {
    _state = EmotionState.connectionChecking;
    notifyListeners();

    try {
      _connectionDetails = await _apiService.checkConnectionDetailed();
      _isConnected = _connectionDetails != null;

      if (_isConnected) {
        // Test all endpoints
        _endpointStatus = await _apiService.testAllEndpoints();
      }

      _state = EmotionState.initial;
    } catch (e) {
      _isConnected = false;
      _connectionDetails = null;
      _state = EmotionState.initial;
    }
    notifyListeners();
  }

  // Enhanced emotion analysis
  Future<void> analyzeEmotion(String text) async {
    _state = EmotionState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _emotionResult = await _apiService.analyzeEmotion(text);
      _state = EmotionState.success;
      _errorMessage = null;

      // Auto-refresh analytics after successful analysis
      if (_analyticsSummary != null) {
        loadAnalytics();
      }
    } catch (e) {
      _state = EmotionState.error;
      _errorMessage = e.toString();
      _emotionResult = null;
    }
    notifyListeners();
  }

  // NEW: Batch emotion analysis
  Future<void> analyzeBatchEmotions(List<String> texts) async {
    if (texts.isEmpty) {
      _setError('Please provide texts for batch analysis');
      return;
    }

    if (!_isConnected) {
      _setError('Please check your connection and try again');
      return;
    }

    _isBatchProcessing = true;
    _batchResults.clear();
    notifyListeners();

    try {
      final results = await _apiService.analyzeBatchEmotions(texts);
      _batchResults = results;

      // Auto-refresh analytics after batch processing
      if (_analyticsSummary != null) {
        loadAnalytics();
      }
    } catch (e) {
      _setError(_getErrorMessage(e));
    } finally {
      _isBatchProcessing = false;
      notifyListeners();
    }
  }

  // NEW: Load demo data
  Future<void> loadDemoData() async {
    try {
      _demoResult = await _apiService.getDemoPredictions();
      notifyListeners();
    } catch (e) {
      // Demo data is optional, don't show error
      _demoResult = null;
    }
  }

  // NEW: Load system metrics
  Future<void> loadSystemMetrics() async {
    try {
      _systemMetrics = await _apiService.getSystemMetrics();
      notifyListeners();
    } catch (e) {
      _systemMetrics = null;
    }
  }

  // NEW: Load analytics summary
  Future<void> loadAnalytics() async {
    try {
      _analyticsSummary = await _apiService.getAnalyticsSummary();
      notifyListeners();
    } catch (e) {
      _analyticsSummary = null;
    }
  }

  // NEW: Load cache statistics
  Future<void> loadCacheStats() async {
    try {
      _cacheStats = await _apiService.getCacheStats();
      notifyListeners();
    } catch (e) {
      _cacheStats = null;
    }
  }

  // NEW: Load model information
  Future<void> loadModelInfo() async {
    try {
      _modelInfo = await _apiService.getModelInfo();
      notifyListeners();
    } catch (e) {
      _modelInfo = null;
    }
  }

  // NEW: Clear cache
  Future<void> clearCache() async {
    try {
      final success = await _apiService.clearCache();
      if (success) {
        await loadCacheStats(); // Refresh cache stats
      }
    } catch (e) {
      _setError('Failed to clear cache');
    }
  }

  // NEW: Toggle auto-refresh for metrics
  void toggleAutoRefreshMetrics() {
    _autoRefreshMetrics = !_autoRefreshMetrics;

    if (_autoRefreshMetrics) {
      _startMetricsTimer();
    } else {
      _stopMetricsTimer();
    }

    notifyListeners();
  }

  void _startMetricsTimer() {
    _metricsTimer?.cancel();
    _metricsTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        loadSystemMetrics();
        loadCacheStats();
      }
    });
  }

  void _stopMetricsTimer() {
    _metricsTimer?.cancel();
    _metricsTimer = null;
  }

  // NEW: Refresh all data
  Future<void> refreshAllData() async {
    await Future.wait([
      checkConnection(),
      loadSystemMetrics(),
      loadAnalytics(),
      loadCacheStats(),
      loadModelInfo(),
      loadDemoData(),
    ]);
  }

  // NEW: Get popular emotion from analytics
  String get mostPopularEmotion {
    if (_analyticsSummary?.emotionCounts.isEmpty ?? true) return 'None';
    return _analyticsSummary!.topEmotion;
  }

  // NEW: Get system health status
  String get systemHealthStatus {
    if (_systemMetrics == null) return 'Unknown';

    final cpuOk = _systemMetrics!.cpuUsage < 80;
    final memoryOk = _systemMetrics!.memoryUsage < 85;
    final successRateOk = _systemMetrics!.successRate > 95;

    if (cpuOk && memoryOk && successRateOk) return 'Excellent';
    if (cpuOk && memoryOk) return 'Good';
    if (cpuOk || memoryOk) return 'Fair';
    return 'Poor';
  }

  // NEW: Get cache efficiency
  String get cacheEfficiency {
    if (_cacheStats == null) return 'Unknown';
    final hitRate = _cacheStats!['hit_rate'] as double? ?? 0.0;
    if (hitRate > 0.9) return 'Excellent';
    if (hitRate > 0.7) return 'Good';
    if (hitRate > 0.5) return 'Fair';
    return 'Poor';
  }

  // Clear result
  void clearResult() {
    _emotionResult = null;
    _state = EmotionState.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // NEW: Clear batch results
  void clearBatchResults() {
    _batchResults.clear();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == EmotionState.error) {
      _state = EmotionState.initial;
    }
    notifyListeners();
  }

  // Enhanced reset
  void reset() {
    _state = EmotionState.initial;
    _emotionResult = null;
    _errorMessage = null;
    _batchResults.clear();
    _stopMetricsTimer();
    _autoRefreshMetrics = false;
    notifyListeners();
  }

  // Private methods
  void _setError(String message) {
    _state = EmotionState.error;
    _errorMessage = message;
    _emotionResult = null;
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('timeout')) {
      return 'Request timeout - please try again';
    } else if (error.toString().contains('Connection')) {
      return AppStrings.connectionError;
    } else if (error.toString().contains('Analysis failed')) {
      return '${AppStrings.analysisError}: ${error.toString().split(':').last.trim()}';
    } else {
      return AppStrings.connectionError;
    }
  }

  // Enhanced API info
  Future<Map<String, dynamic>?> getApiInfo() async {
    try {
      _apiInfo = await _apiService.getApiInfo();
      notifyListeners();
      return _apiInfo;
    } catch (e) {
      return null;
    }
  }

  Future<void> analyzeVideo(
    String videoUrl, {
    int? frameInterval,
    int? maxFrames,
  }) async {
    _isVideoLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final request = VideoAnalysisRequest(
        videoUrl: videoUrl,
        frameInterval: frameInterval ?? 30,
        maxFrames: maxFrames ?? 100,
      );

      _lastVideoResult = await _apiService.analyzeVideo(request);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _lastVideoResult = null;
    } finally {
      _isVideoLoading = false;
      notifyListeners();
    }
  }

  void clearVideoResult() {
    _lastVideoResult = null;
    notifyListeners();
  }
}
