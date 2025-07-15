import 'package:equatable/equatable.dart';

/// Base class for all application errors
abstract class AppError extends Equatable {
  final String message;
  final String code;
  final DateTime timestamp;
  final StackTrace? stackTrace;

  const AppError({
    required this.message,
    required this.code,
    required this.timestamp,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, code, timestamp];

  /// Convert error to user-friendly message
  String get userMessage => message;

  /// Check if error should be reported to crash analytics
  bool get shouldReport => true;

  @override
  String toString() => 'AppError($code): $message';
}

/// Network related errors
class NetworkError extends AppError {
  final int? statusCode;
  final Map<String, dynamic>? response;

  const NetworkError({
    required super.message,
    required super.code,
    required super.timestamp,
    this.statusCode,
    this.response,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, statusCode, response];

  @override
  String get userMessage {
    switch (statusCode) {
      case 401:
        return 'Authentication required. Please log in again.';
      case 403:
        return 'You don\'t have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 500:
        return 'Server error occurred. Please try again later.';
      case null:
        return 'Network connection failed. Please check your internet connection.';
      default:
        return 'Network error occurred. Please try again.';
    }
  }
}

/// Validation errors
class ValidationError extends AppError {
  final Map<String, List<String>> fieldErrors;

  const ValidationError({
    required super.message,
    required super.code,
    required super.timestamp,
    this.fieldErrors = const {},
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, fieldErrors];

  @override
  bool get shouldReport => false; // Don't report validation errors

  String? getFieldError(String field) {
    return fieldErrors[field]?.first;
  }
}

/// Cache related errors
class CacheError extends AppError {
  final String? cacheKey;

  const CacheError({
    required super.message,
    required super.code,
    required super.timestamp,
    this.cacheKey,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, cacheKey];

  @override
  bool get shouldReport => false;
}

/// Business logic errors
class BusinessLogicError extends AppError {
  final String operation;

  const BusinessLogicError({
    required super.message,
    required super.code,
    required super.timestamp,
    required this.operation,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, operation];

  @override
  String get userMessage {
    switch (code) {
      case 'TICKET_INVALID_STATUS_TRANSITION':
        return 'Cannot change ticket status: $message';
      case 'TICKET_ALREADY_ASSIGNED':
        return 'This ticket is already assigned to someone else.';
      case 'INSUFFICIENT_PERMISSIONS':
        return 'You don\'t have permission to perform this action.';
      default:
        return message;
    }
  }
}

/// Authentication errors
class AuthenticationError extends AppError {
  const AuthenticationError({
    required super.message,
    required super.code,
    required super.timestamp,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Authentication failed. Please log in again.';
}

/// Authorization errors
class AuthorizationError extends AppError {
  final String requiredPermission;

  const AuthorizationError({
    required super.message,
    required super.code,
    required super.timestamp,
    required this.requiredPermission,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, requiredPermission];

  @override
  String get userMessage =>
      'You don\'t have permission to perform this action.';
}

/// Unknown/unexpected errors
class UnknownError extends AppError {
  final dynamic originalError;

  const UnknownError({
    required super.message,
    required super.code,
    required super.timestamp,
    this.originalError,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, originalError];
}

/// Error factory for creating appropriate error types
class ErrorFactory {
  static AppError fromException(dynamic exception, [StackTrace? stackTrace]) {
    final timestamp = DateTime.now();

    if (exception is AppError) {
      return exception;
    }

    if (exception is FormatException) {
      return ValidationError(
        message: 'Invalid data format: ${exception.message}',
        code: 'INVALID_FORMAT',
        timestamp: timestamp,
        stackTrace: stackTrace,
      );
    }

    if (exception is ArgumentError) {
      return ValidationError(
        message: 'Invalid argument: ${exception.message}',
        code: 'INVALID_ARGUMENT',
        timestamp: timestamp,
        stackTrace: stackTrace,
      );
    }

    // Default to unknown error
    return UnknownError(
      message: exception.toString(),
      code: 'UNKNOWN_ERROR',
      timestamp: timestamp,
      originalError: exception,
      stackTrace: stackTrace,
    );
  }

  static NetworkError networkError({
    required String message,
    int? statusCode,
    Map<String, dynamic>? response,
    StackTrace? stackTrace,
  }) {
    return NetworkError(
      message: message,
      code: 'NETWORK_ERROR_${statusCode ?? 'UNKNOWN'}',
      timestamp: DateTime.now(),
      statusCode: statusCode,
      response: response,
      stackTrace: stackTrace,
    );
  }

  static ValidationError validationError({
    required String message,
    Map<String, List<String>> fieldErrors = const {},
    StackTrace? stackTrace,
  }) {
    return ValidationError(
      message: message,
      code: 'VALIDATION_ERROR',
      timestamp: DateTime.now(),
      fieldErrors: fieldErrors,
      stackTrace: stackTrace,
    );
  }

  static BusinessLogicError businessLogicError({
    required String message,
    required String operation,
    required String code,
    StackTrace? stackTrace,
  }) {
    return BusinessLogicError(
      message: message,
      code: code,
      timestamp: DateTime.now(),
      operation: operation,
      stackTrace: stackTrace,
    );
  }
}
