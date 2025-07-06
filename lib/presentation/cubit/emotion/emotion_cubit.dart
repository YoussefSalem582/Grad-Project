import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/emotion_result.dart';
import '../../../data/models/system_metrics.dart';
import '../../../data/models/analytics_summary.dart';
import '../../../data/models/demo_result.dart';
import '../../../data/services/emotion_api_service.dart';

part 'emotion_state.dart';

/// Cubit for managing emotion analysis and API operations
class EmotionCubit extends Cubit<EmotionState> {
  final EmotionApiService _apiService;
  Timer? _metricsTimer;

  EmotionCubit(this._apiService) : super(const EmotionInitial()) {
    // Initialize enhanced features on startup
    Future.delayed(Duration.zero, () async {
      try {
        await _initializeEnhancedFeatures();
      } catch (e) {
        // Silently handle initialization errors
        emit(const EmotionInitial());
      }
    });
  }

  @override
  Future<void> close() {
    _metricsTimer?.cancel();
    return super.close();
  }

  /// Initialize enhanced features
  Future<void> _initializeEnhancedFeatures() async {
    await Future.wait([
      loadDemoData(),
      loadSystemMetrics(),
      loadAnalytics(),
      loadCacheStats(),
      loadModelInfo(),
    ]);
  }

  /// Enhanced connection check
  Future<void> checkConnection() async {
    emit(const EmotionConnectionChecking());

    try {
      final connectionDetails = await _apiService.checkConnectionDetailed();
      final isConnected = connectionDetails.isNotEmpty;

      Map<String, bool> endpointStatus = {};
      if (isConnected) {
        // Test all endpoints
        endpointStatus = await _apiService.testAllEndpoints();
      }

      emit(
        EmotionConnectionResult(
          isConnected: isConnected,
          connectionDetails: connectionDetails,
          endpointStatus: endpointStatus,
        ),
      );
    } catch (e) {
      emit(EmotionError('Connection check failed: ${e.toString()}'));
    }
  }

  /// Analyze text emotion
  Future<void> analyzeText(String text) async {
    if (text.trim().isEmpty) {
      emit(const EmotionError('Text cannot be empty'));
      return;
    }

    emit(const EmotionLoading());

    try {
      final result = await _apiService.analyzeEmotion(text);
      emit(EmotionSuccess(result));
    } catch (e) {
      emit(EmotionError(_getErrorMessage(e)));
    }
  }

  /// Load demo data
  Future<void> loadDemoData() async {
    try {
      final demoResult = await _apiService.getDemoResults();
      // Emit demo result as part of the current state
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(demoResult: demoResult));
      } else {
        emit(EmotionDemo(demoResult));
      }
    } catch (e) {
      // Silently handle demo data loading errors
    }
  }

  /// Load system metrics
  Future<void> loadSystemMetrics() async {
    try {
      final metrics = await _apiService.getSystemMetrics();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(systemMetrics: metrics));
      }
    } catch (e) {
      // Silently handle metrics loading errors
    }
  }

  /// Load analytics summary
  Future<void> loadAnalytics() async {
    try {
      final analytics = await _apiService.getAnalyticsSummary();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(analyticsSummary: analytics));
      }
    } catch (e) {
      // Silently handle analytics loading errors
    }
  }

  /// Load cache statistics
  Future<void> loadCacheStats() async {
    try {
      final cacheStats = await _apiService.getCacheStats();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(cacheStats: cacheStats));
      }
    } catch (e) {
      // Silently handle cache stats loading errors
    }
  }

  /// Load model information
  Future<void> loadModelInfo() async {
    try {
      final modelInfo = await _apiService.getModelInfo();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(modelInfo: modelInfo));
      }
    } catch (e) {
      // Silently handle model info loading errors
    }
  }

  /// Clear cache
  Future<void> clearCache() async {
    try {
      final success = await _apiService.clearCache();
      if (success) {
        await loadCacheStats(); // Refresh cache stats
      }
    } catch (e) {
      emit(EmotionError('Failed to clear cache'));
    }
  }

  /// Toggle auto-refresh for metrics
  void toggleAutoRefreshMetrics() {
    if (_metricsTimer?.isActive ?? false) {
      _metricsTimer?.cancel();
    } else {
      _metricsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        loadSystemMetrics();
      });
    }
  }

  /// Clear result
  void clearResult() {
    emit(const EmotionInitial());
  }

  /// Clear error
  void clearError() {
    if (state is EmotionError) {
      emit(const EmotionInitial());
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('timeout')) {
      return 'Request timeout - please try again';
    } else if (error.toString().contains('Connection')) {
      return 'Unable to connect to the server';
    } else if (error.toString().contains('404')) {
      return 'Service endpoint not found';
    } else if (error.toString().contains('500')) {
      return 'Server error - please try again later';
    } else {
      return 'Analysis failed: ${error.toString()}';
    }
  }
}
