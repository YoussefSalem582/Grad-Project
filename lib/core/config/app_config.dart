import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Application configuration with environment support
///
/// This class manages all application configuration settings including:
/// - API endpoints and authentication
/// - Environment-specific settings (dev, staging, production)
/// - Feature flags and debugging options
/// - Cache and performance settings
///
/// Configuration is loaded from .env files based on the environment.
/// This allows easy switching between different backend environments
/// without code changes.
class AppConfig {
  static const String appName = 'EmoSense';
  static const String appVersion = '1.0.0';

  /// Load configuration from environment files
  ///
  /// Loads settings from .env files based on the specified environment:
  /// - 'development' -> .env.development
  /// - 'production' -> .env.production
  /// - default -> .env
  ///
  /// Falls back to default .env file if environment-specific file is not found.
  ///
  /// [environment] The environment to load (development, production, etc.)
  /// Load configuration from environment files
  ///
  /// Loads settings from .env files based on the specified environment:
  /// - 'development' -> .env.development
  /// - 'production' -> .env.production
  /// - default -> .env
  ///
  /// Falls back to default .env file if environment-specific file is not found.
  ///
  /// [environment] The environment to load (development, production, etc.)
  static Future<void> loadConfig({String environment = 'development'}) async {
    String envFile = '.env';
    switch (environment) {
      case 'production':
        envFile = '.env.production';
        break;
      case 'development':
        envFile = '.env.development';
        break;
      default:
        envFile = '.env';
    }

    try {
      await dotenv.load(fileName: envFile);
    } catch (e) {
      // Fallback to default .env file if specific environment file not found
      await dotenv.load(fileName: '.env');
    }
  }

  // ========================================
  // API Configuration
  // ========================================

  /// Backend API base URL (e.g., 'http://localhost:8000' or 'https://api.emosense.com/v1')
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';

  /// API authentication key for backend requests
  static String get apiKey => dotenv.env['API_KEY'] ?? 'default-api-key';

  /// HTTP connection timeout in milliseconds
  static int get connectTimeout =>
      int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? '30000');

  /// HTTP receive timeout in milliseconds
  static int get receiveTimeout =>
      int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30000');

  // ========================================
  // Environment Configuration
  // ========================================

  /// Current environment (development, staging, production)
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';

  /// Whether debug mode is enabled (shows detailed logs, etc.)
  static bool get debugMode =>
      dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  /// Whether to use mock data when backend is unavailable
  static bool get enableMockData =>
      dotenv.env['ENABLE_MOCK_DATA']?.toLowerCase() == 'true';

  /// Whether to enable detailed network request/response logging
  static bool get enableLogging =>
      dotenv.env['ENABLE_LOGGING']?.toLowerCase() == 'true';

  /// Whether to enable analytics tracking
  static bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

  // ========================================
  // Cache Configuration
  // ========================================

  /// Cache timeout in seconds (how long cached data remains valid)
  static int get cacheTimeout =>
      int.parse(dotenv.env['CACHE_TIMEOUT'] ?? '3600');

  /// Maximum cache size in bytes
  /// Maximum cache size in bytes
  static int get maxCacheSize =>
      int.parse(dotenv.env['MAX_CACHE_SIZE'] ?? '104857600');

  // ========================================
  // Analysis Configuration
  // ========================================

  /// Maximum text length allowed for emotion analysis
  static const int maxTextLength = 5000;

  /// Maximum audio duration in seconds for analysis
  static const int maxAudioDuration = 300; // 5 minutes in seconds

  /// Maximum number of items in batch analysis
  static const int maxBatchSize = 100;

  // ========================================
  // Feature Flags
  // ========================================

  /// Whether voice analysis features are enabled
  static const bool enableVoiceAnalysis = true;

  /// Whether social media analysis features are enabled
  static const bool enableSocialAnalysis = true;

  /// Whether batch processing features are enabled
  static const bool enableBatchProcessing = true;

  /// Whether offline mode is supported (currently disabled)
  static const bool enableOfflineMode = false;

  // ========================================
  // Pagination Settings
  // ========================================

  /// Default number of items per page in lists
  static const int defaultPageSize = 20;

  /// Maximum number of items per page allowed
  static const int maxPageSize = 100;

  // ========================================
  // Utility Methods
  // ========================================

  /// Returns true if running in production environment
  static bool get isProduction => environment == 'production';

  /// Returns true if running in development environment
  static bool get isDevelopment => environment == 'development';

  /// Get full API endpoint URL by combining base URL with path
  ///
  /// Automatically adds leading slash if not present in path.
  ///
  /// Example:
  /// ```dart
  /// String healthUrl = AppConfig.getEndpoint('/health');
  /// // Returns: 'http://localhost:8002/health'
  /// ```
  ///
  /// [path] The API endpoint path (e.g., '/health', '/predict')
  static String getEndpoint(String path) {
    return '$baseUrl${path.startsWith('/') ? path : '/$path'}';
  }
}
