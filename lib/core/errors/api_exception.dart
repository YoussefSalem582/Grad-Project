/// Custom exception class for API-related errors
///
/// This class provides a structured way to handle errors that occur during
/// API communication. It includes:
/// - Human-readable error messages
/// - HTTP status codes for debugging
/// - Categorized error types for different handling strategies
/// - Optional additional data from the server
///
/// Using this custom exception allows the app to provide consistent error
/// handling and user-friendly error messages across all API interactions.
///
/// Example usage:
/// ```dart
/// try {
///   final response = await apiClient.get('/data');
/// } on ApiException catch (e) {
///   if (e.type == ApiExceptionType.network) {
///     showNetworkErrorDialog();
///   } else {
///     showGenericErrorMessage(e.message);
///   }
/// }
/// ```
class ApiException implements Exception {
  /// Human-readable error message that can be shown to users
  final String message;

  /// HTTP status code from the server response (0 if no response)
  final int statusCode;

  /// Categorized error type for different handling strategies
  final ApiExceptionType type;

  /// Optional additional data from the server response
  final dynamic data;

  const ApiException({
    required this.message,
    required this.statusCode,
    required this.type,
    this.data,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode, Type: $type)';
  }
}

/// Enumeration of different types of API exceptions
///
/// This categorization allows the application to handle different types
/// of errors appropriately:
/// - Network errors: Show retry options, check connectivity
/// - Timeout errors: Suggest trying again later
/// - Server errors: Log for debugging, show maintenance message
/// - Client errors: Validate input, show specific error message
/// - Cancel errors: Usually no user action needed
/// - Unknown errors: Log for investigation, show generic message
enum ApiExceptionType {
  /// Network connectivity issues (no internet, DNS failure, etc.)
  network,

  /// Request timed out (connection, send, or receive timeout)
  timeout,

  /// Server returned an error status code (5xx errors)
  server,

  /// Client error in the request (4xx errors, validation failures)
  client,

  /// Request was cancelled by the user or application
  cancel,

  /// Unknown or unexpected error type
  unknown,
}

/// Extension to provide user-friendly error messages for each exception type
///
/// This extension adds a convenient way to get standardized, user-friendly
/// error messages for each type of API exception. These messages are designed
/// to be informative but not technical, suitable for display to end users.
///
/// Example usage:
/// ```dart
/// void showErrorMessage(ApiExceptionType errorType) {
///   final message = errorType.message;
///   showDialog(context: context, content: Text(message));
/// }
/// ```
extension ApiExceptionTypeExtension on ApiExceptionType {
  /// Get a user-friendly error message for this exception type
  String get message {
    switch (this) {
      case ApiExceptionType.network:
        return 'Network connection error. Please check your internet connection.';
      case ApiExceptionType.timeout:
        return 'Request timeout. Please try again.';
      case ApiExceptionType.server:
        return 'Server error occurred. Please try again later.';
      case ApiExceptionType.client:
        return 'Invalid request. Please check your input.';
      case ApiExceptionType.cancel:
        return 'Request was cancelled.';
      case ApiExceptionType.unknown:
        return 'An unexpected error occurred.';
    }
  }
}
