/// Enhanced Application Configuration
///
/// This file contains all configuration settings for the CustomerSense Pro app,
/// including API endpoints, timeouts, feature flags, and environment-specific settings.
///
/// Usage:
/// - Update API_BASE_URL to point to your backend server
/// - Set ENABLE_MOCK_MODE to false when connecting to real backend
/// - Customize timeouts and limits based on your infrastructure
/// - Enable/disable features using the feature flags section

class AppConfig {
  // =============================================================================
  // APPLICATION INFO
  // =============================================================================

  /// Application name displayed in UI
  static const String appName = 'CustomerSense Pro';

  /// Current app version
  static const String appVersion = '1.0.0';

  /// Build number for internal tracking
  static const String buildNumber = '1';

  // =============================================================================
  // ENVIRONMENT CONFIGURATION
  // =============================================================================

  /// Current environment (development, staging, production)
  static const Environment currentEnvironment = Environment.development;

  /// Whether to enable mock data mode (useful for development/testing)
  /// Set to false when connecting to real backend
  static const bool ENABLE_MOCK_MODE = true;

  /// Enable debug logging for API calls and responses
  static const bool ENABLE_DEBUG_LOGGING = true;

  /// Enable crash analytics and error reporting
  static const bool ENABLE_CRASH_ANALYTICS = false;

  // =============================================================================
  // API CONFIGURATION
  // =============================================================================

  /// Base URL for the API server
  ///
  /// Examples:
  /// - Local development: 'http://localhost:8002'
  /// - Local network: 'http://192.168.1.100:8002'
  /// - Production: 'https://api.customersense.pro/v1'
  /// - Staging: 'https://staging-api.customersense.pro/v1'
  static const String baseUrl = 'http://localhost:8002';

  /// API version prefix (if your backend uses versioning)
  static const String apiVersion = 'v1';

  /// API key for authentication (if required by your backend)
  /// Leave empty if your backend doesn't require authentication
  static const String apiKey = '';

  /// Custom headers to include with all API requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'CustomerSense-Mobile/1.0.0',
    // Add your custom headers here:
    // 'Authorization': 'Bearer your-token',
    // 'X-Client-Version': '1.0.0',
  };

  // =============================================================================
  // API ENDPOINTS
  // =============================================================================

  /// All API endpoints used by the application
  /// Modify these if your backend uses different endpoint paths
  static const ApiEndpoints endpoints = ApiEndpoints();

  // =============================================================================
  // TIMEOUT CONFIGURATION
  // =============================================================================

  /// Connection timeout for establishing initial connection (milliseconds)
  static const int connectTimeout = 30000; // 30 seconds

  /// Receive timeout for receiving response data (milliseconds)
  static const int receiveTimeout = 30000; // 30 seconds

  /// Send timeout for sending request data (milliseconds)
  static const int sendTimeout = 30000; // 30 seconds

  /// Timeout for quick health checks (milliseconds)
  static const int healthCheckTimeout = 5000; // 5 seconds

  /// Timeout for video analysis requests (milliseconds)
  static const int videoAnalysisTimeout = 120000; // 2 minutes

  /// Timeout for batch processing requests (milliseconds)
  static const int batchProcessingTimeout = 60000; // 1 minute

  // =============================================================================
  // RETRY CONFIGURATION
  // =============================================================================

  /// Maximum number of retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Delay between retry attempts (milliseconds)
  static const int retryDelay = 1000; // 1 second

  /// Whether to use exponential backoff for retries
  static const bool useExponentialBackoff = true;

  // =============================================================================
  // ANALYSIS LIMITS
  // =============================================================================

  /// Maximum length of text for analysis
  static const int maxTextLength = 5000;

  /// Maximum audio duration for voice analysis (seconds)
  static const int maxAudioDuration = 300; // 5 minutes

  /// Maximum video duration for video analysis (seconds)
  static const int maxVideoDuration = 600; // 10 minutes

  /// Maximum file size for uploads (bytes)
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB

  /// Maximum number of items in batch processing
  static const int maxBatchSize = 100;

  /// Maximum number of concurrent requests
  static const int maxConcurrentRequests = 5;

  // =============================================================================
  // CACHE CONFIGURATION
  // =============================================================================

  /// Cache timeout for analysis results (seconds)
  static const int cacheTimeout = 3600; // 1 hour

  /// Maximum cache size (bytes)
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  /// Whether to enable result caching
  static const bool enableResultCaching = true;

  /// Whether to cache offline for improved performance
  static const bool enableOfflineCaching = true;

  // =============================================================================
  // FEATURE FLAGS
  // =============================================================================

  /// Enable voice/audio analysis features
  static const bool enableVoiceAnalysis = true;

  /// Enable social media analysis features
  static const bool enableSocialAnalysis = true;

  /// Enable video analysis features
  static const bool enableVideoAnalysis = true;

  /// Enable batch processing features
  static const bool enableBatchProcessing = true;

  /// Enable offline mode functionality
  static const bool enableOfflineMode = false;

  /// Enable real-time analysis features
  static const bool enableRealtimeAnalysis = true;

  /// Enable advanced analytics dashboard
  static const bool enableAdvancedAnalytics = true;

  /// Enable export functionality
  static const bool enableExportFeatures = true;

  // =============================================================================
  // UI CONFIGURATION
  // =============================================================================

  /// Default page size for paginated lists
  static const int defaultPageSize = 20;

  /// Maximum page size for paginated lists
  static const int maxPageSize = 100;

  /// Animation duration for UI transitions (milliseconds)
  static const int animationDuration = 300;

  /// Whether to enable haptic feedback
  static const bool enableHapticFeedback = true;

  /// Whether to enable dark mode by default
  static const bool defaultDarkMode = false;

  // =============================================================================
  // ANALYTICS CONFIGURATION
  // =============================================================================

  /// Whether to collect usage analytics
  static const bool enableUsageAnalytics = false;

  /// Whether to collect performance metrics
  static const bool enablePerformanceMetrics = true;

  /// Interval for sending analytics data (seconds)
  static const int analyticsUploadInterval = 300; // 5 minutes

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Get the full API URL for an endpoint
  static String getApiUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }

  /// Get headers with authentication if API key is provided
  static Map<String, String> getAuthenticatedHeaders() {
    final headers = Map<String, String>.from(defaultHeaders);
    if (apiKey.isNotEmpty) {
      headers['Authorization'] = 'Bearer $apiKey';
    }
    return headers;
  }

  /// Check if a feature is enabled
  static bool isFeatureEnabled(String feature) {
    switch (feature.toLowerCase()) {
      case 'voice':
        return enableVoiceAnalysis;
      case 'social':
        return enableSocialAnalysis;
      case 'video':
        return enableVideoAnalysis;
      case 'batch':
        return enableBatchProcessing;
      case 'offline':
        return enableOfflineMode;
      case 'realtime':
        return enableRealtimeAnalysis;
      case 'analytics':
        return enableAdvancedAnalytics;
      case 'export':
        return enableExportFeatures;
      default:
        return false;
    }
  }
}

/// Environment types
enum Environment { development, staging, production }

/// API Endpoints Configuration
///
/// Centralized management of all API endpoints.
/// Modify these paths if your backend uses different routes.
class ApiEndpoints {
  const ApiEndpoints();

  // =============================================================================
  // CORE ENDPOINTS
  // =============================================================================

  /// Health check endpoint - used to verify server connectivity
  String get health => '/health';

  /// Main prediction endpoint for text emotion analysis
  String get predict => '/predict';

  /// Batch prediction endpoint for multiple texts
  String get batchPredict => '/batch-predict';

  // =============================================================================
  // ANALYSIS ENDPOINTS
  // =============================================================================

  /// Video analysis endpoint
  String get videoAnalysis => '/analyze-video';

  /// Voice/audio analysis endpoint
  String get voiceAnalysis => '/analyze-voice';

  /// Social media analysis endpoint
  String get socialAnalysis => '/analyze-social';

  /// Real-time analysis endpoint (WebSocket or Server-Sent Events)
  String get realtimeAnalysis => '/analyze-realtime';

  // =============================================================================
  // METRICS & MONITORING ENDPOINTS
  // =============================================================================

  /// System metrics endpoint
  String get metrics => '/metrics';

  /// Analytics summary endpoint
  String get analytics => '/analytics';

  /// Cache statistics endpoint
  String get cacheStats => '/cache-stats';

  /// Clear cache endpoint
  String get clearCache => '/clear-cache';

  // =============================================================================
  // MODEL & INFORMATION ENDPOINTS
  // =============================================================================

  /// Model information endpoint
  String get modelInfo => '/model-info';

  /// API information endpoint
  String get apiInfo => '/api-info';

  /// Available features endpoint
  String get features => '/features';

  // =============================================================================
  // DEMO & TESTING ENDPOINTS
  // =============================================================================

  /// Demo results endpoint
  String get demo => '/demo';

  /// Test all endpoints
  String get testAll => '/test-all';

  /// Ping endpoint for connectivity testing
  String get ping => '/ping';

  // =============================================================================
  // DATA MANAGEMENT ENDPOINTS
  // =============================================================================

  /// History endpoint for analysis results
  String get history => '/history';

  /// Export data endpoint
  String get export => '/export';

  /// Import data endpoint
  String get import => '/import';

  /// User data endpoint
  String get userData => '/user-data';

  // =============================================================================
  // AUTHENTICATION ENDPOINTS (if needed)
  // =============================================================================

  /// Login endpoint
  String get login => '/auth/login';

  /// Logout endpoint
  String get logout => '/auth/logout';

  /// Token refresh endpoint
  String get refreshToken => '/auth/refresh';

  /// User profile endpoint
  String get profile => '/auth/profile';

  // =============================================================================
  // HELPER METHODS
  // =============================================================================

  /// Get all core endpoints for testing connectivity
  List<String> get coreEndpoints => [
    health,
    predict,
    metrics,
    analytics,
    modelInfo,
  ];

  /// Get all analysis endpoints
  List<String> get analysisEndpoints => [
    predict,
    batchPredict,
    videoAnalysis,
    voiceAnalysis,
    socialAnalysis,
  ];

  /// Get all monitoring endpoints
  List<String> get monitoringEndpoints => [metrics, analytics, cacheStats];
}
