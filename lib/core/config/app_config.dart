/// Application configuration
class AppConfig {
  static const String appName = 'CustomerSense Pro';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.customersense.pro/v1';
  static const String apiKey = 'your-api-key';
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Analysis Configuration
  static const int maxTextLength = 5000;
  static const int maxAudioDuration = 300; // 5 minutes in seconds
  static const int maxBatchSize = 100;

  // Cache Configuration
  static const int cacheTimeout = 3600; // 1 hour in seconds
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Feature Flags
  static const bool enableVoiceAnalysis = true;
  static const bool enableSocialAnalysis = true;
  static const bool enableBatchProcessing = true;
  static const bool enableOfflineMode = false;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}
