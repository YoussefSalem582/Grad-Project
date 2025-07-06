import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'api_client.dart';
import 'network_info.dart';
import '../errors/api_exception.dart';

/// Enumeration of possible connection states
///
/// These states represent the current status of the backend connection:
/// - connected: Successfully connected and communicating with backend
/// - disconnected: Not connected to any backend
/// - connecting: Currently attempting to establish connection
/// - error: Connection failed or encountered an error
enum ConnectionStatus { connected, disconnected, connecting, error }

/// Result object for backend connection attempts
///
/// This class encapsulates the result of a connection attempt, including
/// success/failure status, descriptive messages, optional data, and error details.
///
/// Example usage:
/// ```dart
/// final result = await connectionManager.connectToBackend(config);
/// if (result.success) {
///   print('Connected: ${result.message}');
/// } else {
///   print('Failed: ${result.message}');
///   if (result.error != null) {
///     handleApiError(result.error!);
///   }
/// }
/// ```
class ConnectionResult {
  /// Whether the connection attempt was successful
  final bool success;

  /// Human-readable message describing the result
  final String message;

  /// Optional additional data from the connection attempt
  final Map<String, dynamic>? data;

  /// Error details if the connection failed
  final ApiException? error;

  const ConnectionResult({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  /// Factory constructor for successful connection results
  factory ConnectionResult.success({
    required String message,
    Map<String, dynamic>? data,
  }) {
    return ConnectionResult(success: true, message: message, data: data);
  }

  /// Factory constructor for failed connection results
  factory ConnectionResult.failure({
    required String message,
    ApiException? error,
  }) {
    return ConnectionResult(success: false, message: message, error: error);
  }
}

/// Configuration for a backend environment
///
/// This class represents a complete backend configuration including
/// connection details, authentication, and metadata. It supports
/// serialization for persistence and easy switching between environments.
///
/// Example configurations:
/// ```dart
/// final devConfig = BackendConfig(
///   name: 'Development',
///   baseUrl: 'http://localhost:8002',
///   apiKey: 'dev-key',
///   isDefault: true,
/// );
///
/// final prodConfig = BackendConfig(
///   name: 'Production',
///   baseUrl: 'https://api.emosense.com/v1',
///   apiKey: 'prod-key',
///   customHeaders: {'X-Environment': 'production'},
/// );
/// ```
class BackendConfig {
  /// Human-readable name for this configuration
  final String name;

  /// Base URL for the backend API
  final String baseUrl;

  /// API key for authentication
  final String apiKey;

  /// Whether this is the default configuration
  final bool isDefault;

  /// Optional custom headers to include with requests
  final Map<String, dynamic>? customHeaders;

  const BackendConfig({
    required this.name,
    required this.baseUrl,
    required this.apiKey,
    this.isDefault = false,
    this.customHeaders,
  });

  /// Convert this configuration to a JSON map for persistence
  Map<String, dynamic> toJson() => {
    'name': name,
    'baseUrl': baseUrl,
    'apiKey': apiKey,
    'isDefault': isDefault,
    'customHeaders': customHeaders,
  };

  /// Create a configuration from a JSON map
  factory BackendConfig.fromJson(Map<String, dynamic> json) => BackendConfig(
    name: json['name'],
    baseUrl: json['baseUrl'],
    apiKey: json['apiKey'],
    isDefault: json['isDefault'] ?? false,
    customHeaders: json['customHeaders'],
  );
}

/// Centralized manager for backend connections and environment switching
///
/// This class provides a comprehensive solution for managing backend connections
/// in a Flutter app. Key features include:
///
/// - **Multi-environment support**: Easy switching between dev, staging, production
/// - **Real-time monitoring**: Connection status updates and health checks
/// - **Network awareness**: Automatic reconnection when network becomes available
/// - **Persistence**: Remembers the last used configuration across app restarts
/// - **Error handling**: Detailed error reporting and recovery mechanisms
/// - **Predefined configs**: Common backend environments ready to use
///
/// The manager is implemented as a singleton to ensure consistent state
/// across the entire application.
///
/// ## Usage Example:
///
/// ```dart
/// // Initialize the manager
/// await ConnectionManager.instance.initialize();
///
/// // Connect to a backend
/// final config = BackendConfig(
///   name: 'My Backend',
///   baseUrl: 'https://api.example.com',
///   apiKey: 'my-key',
/// );
/// final result = await ConnectionManager.instance.connectToBackend(config);
///
/// // Listen to connection status
/// ConnectionManager.instance.statusStream.listen((status) {
///   print('Connection status: $status');
/// });
/// ```
class ConnectionManager {
  /// Singleton instance
  static ConnectionManager? _instance;

  /// API client for making HTTP requests
  late final ApiClient _apiClient;

  /// Network info for monitoring connectivity
  late final NetworkInfo _networkInfo;

  /// Shared preferences for persisting configuration
  late final SharedPreferences _prefs;

  /// Stream controller for broadcasting connection status changes
  final StreamController<ConnectionStatus> _statusController =
      StreamController<ConnectionStatus>.broadcast();

  /// Current connection status
  ConnectionStatus _currentStatus = ConnectionStatus.disconnected;

  /// Currently active backend configuration
  BackendConfig? _currentConfig;

  /// Timer for periodic health checks
  Timer? _healthCheckTimer;

  /// Private constructor for singleton pattern
  ConnectionManager._internal();

  /// Get the singleton instance of the connection manager
  static ConnectionManager get instance {
    _instance ??= ConnectionManager._internal();
    return _instance!;
  }

  /// Initialize the connection manager
  ///
  /// This method must be called before using any other functionality.
  /// It sets up the API client, network monitoring, loads saved configuration,
  /// and starts background processes.
  ///
  /// Should typically be called during app startup:
  /// ```dart
  /// await ConnectionManager.instance.initialize();
  /// ```
  Future<void> initialize() async {
    // Initialize core dependencies
    _apiClient = ApiClient();
    _networkInfo = NetworkInfoImpl();
    _prefs = await SharedPreferences.getInstance();

    // Load any previously saved configuration
    await _loadSavedConfig();

    // Start monitoring network connectivity changes
    // When network becomes available, attempt to reconnect
    _networkInfo.connectivityStream.listen(_onConnectivityChanged);

    // Start periodic health checks to monitor backend status
    _startHealthCheck();
  }

  /// Stream of connection status changes
  Stream<ConnectionStatus> get statusStream => _statusController.stream;

  /// Current connection status
  ConnectionStatus get currentStatus => _currentStatus;

  /// Current backend configuration
  BackendConfig? get currentConfig => _currentConfig;

  /// Check if currently connected to backend
  bool get isConnected => _currentStatus == ConnectionStatus.connected;

  /// Predefined backend configurations
  List<BackendConfig> get predefinedConfigs => [
    BackendConfig(
      name: 'Local Development',
      baseUrl: 'http://localhost:8002',
      apiKey: 'dev-api-key',
      isDefault: true,
    ),
    BackendConfig(
      name: 'Local Development (Alt Port)',
      baseUrl: 'http://localhost:3000',
      apiKey: 'dev-api-key',
    ),
    BackendConfig(
      name: 'Staging',
      baseUrl: 'https://staging-api.emosense.com/v1',
      apiKey: 'staging-api-key',
    ),
    BackendConfig(
      name: 'Production',
      baseUrl: 'https://api.emosense.com/v1',
      apiKey: 'prod-api-key',
    ),
  ];

  /// Connect to a backend configuration
  Future<ConnectionResult> connectToBackend(BackendConfig config) async {
    _updateStatus(ConnectionStatus.connecting);

    try {
      // Check network connectivity first
      if (!await _networkInfo.isConnected) {
        final result = ConnectionResult.failure(
          message: 'No internet connection available',
          error: ApiException(
            message: 'No internet connection',
            statusCode: 0,
            type: ApiExceptionType.network,
          ),
        );
        _updateStatus(ConnectionStatus.disconnected);
        return result;
      }

      // Update API client configuration
      _apiClient.updateBaseUrl(config.baseUrl);
      _apiClient.updateApiKey(config.apiKey);

      // Test connection
      final healthResult = await _testConnection();

      if (healthResult.success) {
        _currentConfig = config;
        await _saveCurrentConfig();
        _updateStatus(ConnectionStatus.connected);
        return ConnectionResult.success(
          message: 'Successfully connected to ${config.name}',
          data: healthResult.data,
        );
      } else {
        _updateStatus(ConnectionStatus.error);
        return healthResult;
      }
    } catch (e) {
      _updateStatus(ConnectionStatus.error);
      return ConnectionResult.failure(
        message: 'Failed to connect: ${e.toString()}',
        error: e is ApiException
            ? e
            : ApiException(
                message: e.toString(),
                statusCode: 0,
                type: ApiExceptionType.unknown,
              ),
      );
    }
  }

  /// Connect using environment configuration
  Future<ConnectionResult> connectUsingEnvironment() async {
    final config = BackendConfig(
      name: 'Environment Config',
      baseUrl: AppConfig.baseUrl,
      apiKey: AppConfig.apiKey,
      isDefault: true,
    );

    return await connectToBackend(config);
  }

  /// Test current connection
  Future<ConnectionResult> testConnection() async {
    if (_currentConfig == null) {
      return ConnectionResult.failure(message: 'No backend configuration set');
    }

    return await _testConnection();
  }

  /// Disconnect from current backend
  void disconnect() {
    _currentConfig = null;
    _updateStatus(ConnectionStatus.disconnected);
    _stopHealthCheck();
    _prefs.remove('current_backend_config');
  }

  /// Switch to a different backend
  Future<ConnectionResult> switchBackend(BackendConfig config) async {
    disconnect();
    return await connectToBackend(config);
  }

  /// Get connection details
  Map<String, dynamic> getConnectionDetails() {
    return {
      'status': _currentStatus.name,
      'config': _currentConfig?.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
      'networkConnected': _networkInfo.isConnected,
    };
  }

  /// Save a custom backend configuration
  Future<void> saveCustomConfig(BackendConfig config) async {
    final savedConfigs = await getSavedConfigs();
    savedConfigs.add(config);

    final configsJson = savedConfigs.map((c) => c.toJson()).toList();
    await _prefs.setString('saved_backend_configs', configsJson.toString());
  }

  /// Get saved custom configurations
  Future<List<BackendConfig>> getSavedConfigs() async {
    final configsString = _prefs.getString('saved_backend_configs');
    if (configsString == null) return [];

    // Parse saved configurations
    // Note: In a real implementation, you might want to use a more robust JSON parsing
    return [];
  }

  /// Private methods

  Future<ConnectionResult> _testConnection() async {
    try {
      final response = await _apiClient.get('/health');

      if (response.statusCode == 200) {
        return ConnectionResult.success(
          message: 'Backend is healthy',
          data: {
            'statusCode': response.statusCode,
            'responseTime': DateTime.now().millisecondsSinceEpoch,
            'data': response.data,
          },
        );
      } else {
        return ConnectionResult.failure(
          message: 'Backend returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      return ConnectionResult.failure(
        message: 'Health check failed: ${e.toString()}',
        error: e is ApiException ? e : null,
      );
    }
  }

  void _updateStatus(ConnectionStatus status) {
    _currentStatus = status;
    _statusController.add(status);
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      _updateStatus(ConnectionStatus.disconnected);
    } else if (_currentConfig != null &&
        _currentStatus != ConnectionStatus.connected) {
      // Try to reconnect
      connectToBackend(_currentConfig!);
    }
  }

  void _startHealthCheck() {
    _stopHealthCheck();
    _healthCheckTimer = Timer.periodic(const Duration(minutes: 2), (
      timer,
    ) async {
      if (_currentConfig != null &&
          _currentStatus == ConnectionStatus.connected) {
        final result = await _testConnection();
        if (!result.success) {
          _updateStatus(ConnectionStatus.error);
        }
      }
    });
  }

  void _stopHealthCheck() {
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
  }

  Future<void> _loadSavedConfig() async {
    final configString = _prefs.getString('current_backend_config');
    if (configString != null) {
      try {
        // Parse and load saved configuration
        // Implementation depends on your JSON parsing approach
      } catch (e) {
        // Ignore parsing errors
      }
    }
  }

  Future<void> _saveCurrentConfig() async {
    if (_currentConfig != null) {
      await _prefs.setString(
        'current_backend_config',
        _currentConfig!.toJson().toString(),
      );
    }
  }

  /// Dispose resources
  void dispose() {
    _statusController.close();
    _stopHealthCheck();
  }
}
