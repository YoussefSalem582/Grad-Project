import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import '../errors/api_exception.dart';

/// Modern HTTP API client using Dio for backend communication
///
/// This class provides a centralized, robust way to make HTTP requests to the backend.
/// It includes:
/// - Automatic error handling and conversion to typed exceptions
/// - Request/response logging for debugging
/// - Configurable timeouts and retry logic
/// - Authentication header management
/// - Base URL management for easy environment switching
///
/// The client is implemented as a singleton to ensure consistent configuration
/// across the entire application.
///
/// Example usage:
/// ```dart
/// final client = ApiClient();
/// try {
///   final response = await client.get('/health');
///   print('Backend is healthy: ${response.data}');
/// } on ApiException catch (e) {
///   print('API Error: ${e.message}');
/// }
/// ```
class ApiClient {
  /// The underlying Dio HTTP client instance
  late final Dio _dio;

  /// Singleton instance to ensure consistent configuration
  static ApiClient? _instance;

  /// Private constructor for singleton pattern
  ApiClient._internal() {
    _dio = Dio();
    _setupDio();
  }

  /// Factory constructor that returns the singleton instance
  factory ApiClient() {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Get access to the underlying Dio instance
  ///
  /// Useful for advanced use cases that need direct access to Dio features.
  /// Generally, prefer using the wrapper methods (get, post, etc.) instead.
  /// Get access to the underlying Dio instance
  ///
  /// Useful for advanced use cases that need direct access to Dio features.
  /// Generally, prefer using the wrapper methods (get, post, etc.) instead.
  Dio get dio => _dio;

  /// Configure the Dio HTTP client with app-specific settings
  ///
  /// Sets up:
  /// - Base URL from app configuration
  /// - Timeout values for connection and data transfer
  /// - Default headers including authentication
  /// - Logging interceptor for development debugging
  /// - Error handling interceptor for consistent error processing
  void _setupDio() {
    // Configure base options for all requests
    _dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
      sendTimeout: Duration(milliseconds: AppConfig.connectTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AppConfig.apiKey}',
      },
    );

    // Add pretty logging interceptor for development debugging
    // Only enabled when both logging and debug mode are turned on
    if (AppConfig.enableLogging && AppConfig.debugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true, // Log request headers
          requestBody: true, // Log request body
          responseBody: true, // Log response body
          responseHeader: false, // Skip response headers (too verbose)
          error: true, // Log errors
          compact: true, // Compact format
          maxWidth: 90, // Terminal width
        ),
      );
    }

    // Add error handling interceptor to convert Dio exceptions to typed API exceptions
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          // Convert DioException to our custom ApiException
          final apiException = _handleDioError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: apiException,
              response: error.response,
              type: error.type,
            ),
          );
        },
      ),
    );
  }

  /// Convert Dio errors to our custom ApiException with user-friendly messages
  ///
  /// This method analyzes different types of Dio exceptions and converts them
  /// to our custom ApiException with appropriate error types and messages.
  /// This provides consistent error handling across the application.
  ///
  /// [error] The DioException to convert
  /// Returns: ApiException with appropriate error type and message
  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      // Connection, send, or receive timeouts
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
          type: ApiExceptionType.timeout,
        );

      // Network connectivity issues
      case DioExceptionType.connectionError:
        return ApiException(
          message:
              'No internet connection. Please check your connection and try again.',
          statusCode: 0,
          type: ApiExceptionType.network,
        );

      // Server responded with an error status code
      case DioExceptionType.badResponse:
        return ApiException(
          message: error.response?.data?['message'] ?? 'Server error occurred.',
          statusCode: error.response?.statusCode ?? 500,
          type: ApiExceptionType.server,
        );

      // Request was cancelled
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled.',
          statusCode: 0,
          type: ApiExceptionType.cancel,
        );

      // Any other unknown error
      default:
        return ApiException(
          message: 'An unexpected error occurred.',
          statusCode: 0,
          type: ApiExceptionType.unknown,
        );
    }
  }

  /// Update the API key for authentication
  ///
  /// Useful when the API key changes or when switching between environments
  /// that require different authentication credentials.
  ///
  /// [apiKey] The new API key to use for requests
  void updateApiKey(String apiKey) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
  }

  /// Update the base URL for API requests
  ///
  /// Useful when switching between different backend environments
  /// (development, staging, production) at runtime.
  ///
  /// [baseUrl] The new base URL (e.g., 'https://api.example.com/v1')
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Make a GET request to the specified endpoint
  ///
  /// [path] The API endpoint path (e.g., '/health', '/users')
  /// [queryParameters] Optional query parameters to include in the URL
  /// [options] Optional Dio request options to override defaults
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Returns: The HTTP response from the server
  /// Throws: ApiException if the request fails
  ///
  /// Example:
  /// ```dart
  /// final response = await client.get('/users', queryParameters: {'page': 1});
  /// ```
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : _handleDioError(e);
    }
  }

  /// Make a POST request to the specified endpoint
  ///
  /// [path] The API endpoint path (e.g., '/users', '/login')
  /// [data] The request body data (will be JSON encoded)
  /// [queryParameters] Optional query parameters to include in the URL
  /// [options] Optional Dio request options to override defaults
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Returns: The HTTP response from the server
  /// Throws: ApiException if the request fails
  ///
  /// Example:
  /// ```dart
  /// final response = await client.post('/login', data: {'email': 'user@example.com'});
  /// ```
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : _handleDioError(e);
    }
  }

  /// Make a PUT request to the specified endpoint
  ///
  /// Used for updating existing resources on the server.
  ///
  /// [path] The API endpoint path (e.g., '/users/123')
  /// [data] The request body data (will be JSON encoded)
  /// [queryParameters] Optional query parameters to include in the URL
  /// [options] Optional Dio request options to override defaults
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Returns: The HTTP response from the server
  /// Throws: ApiException if the request fails
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : _handleDioError(e);
    }
  }

  /// Make a DELETE request to the specified endpoint
  ///
  /// Used for deleting resources on the server.
  ///
  /// [path] The API endpoint path (e.g., '/users/123')
  /// [data] Optional request body data
  /// [queryParameters] Optional query parameters to include in the URL
  /// [options] Optional Dio request options to override defaults
  /// [cancelToken] Optional token to cancel the request
  ///
  /// Returns: The HTTP response from the server
  /// Throws: ApiException if the request fails
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e.error is ApiException
          ? e.error as ApiException
          : _handleDioError(e);
    }
  }
}
