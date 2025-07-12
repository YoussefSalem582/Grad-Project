import 'package:equatable/equatable.dart';
import '../errors/app_error.dart';

/// Result type for handling success and error states
sealed class Result<T> extends Equatable {
  const Result();

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Get success data (throws if error)
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    throw StateError('Tried to get data from error result');
  }

  /// Get error (throws if success)
  AppError get error {
    if (this is Error<T>) {
      return (this as Error<T>).error;
    }
    throw StateError('Tried to get error from success result');
  }

  /// Get data or null
  T? get dataOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Get error or null
  AppError? get errorOrNull {
    if (this is Error<T>) {
      return (this as Error<T>).error;
    }
    return null;
  }

  /// Transform success value
  Result<R> map<R>(R Function(T) transform) {
    return switch (this) {
      Success<T>(data: final data) => Success(transform(data)),
      Error<T>(error: final error) => Error(error),
    };
  }

  /// Transform error
  Result<T> mapError(AppError Function(AppError) transform) {
    return switch (this) {
      Success<T>() => this,
      Error<T>(error: final error) => Error(transform(error)),
    };
  }

  /// Chain operations
  Result<R> flatMap<R>(Result<R> Function(T) transform) {
    return switch (this) {
      Success<T>(data: final data) => transform(data),
      Error<T>(error: final error) => Error(error),
    };
  }

  /// Execute action if success
  Result<T> onSuccess(void Function(T) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Execute action if error
  Result<T> onError(void Function(AppError) action) {
    if (this is Error<T>) {
      action((this as Error<T>).error);
    }
    return this;
  }

  /// Fold result into single value
  R fold<R>(
    R Function(T) onSuccess,
    R Function(AppError) onError,
  ) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),
      Error<T>(error: final error) => onError(error),
    };
  }

  /// Get value or default
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T>(data: final data) => data,
      Error<T>() => defaultValue,
    };
  }

  /// Get value or compute default
  T getOrElseGet(T Function() defaultProvider) {
    return switch (this) {
      Success<T>(data: final data) => data,
      Error<T>() => defaultProvider(),
    };
  }

  @override
  List<Object?> get props => switch (this) {
    Success<T>(data: final data) => [data],
    Error<T>(error: final error) => [error],
  };
}

/// Success result
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

/// Error result
final class Error<T> extends Result<T> {
  final AppError error;

  const Error(this.error);

  @override
  String toString() => 'Error($error)';
}

/// Extensions for async results
extension FutureResultExtension<T> on Future<Result<T>> {
  /// Transform future result
  Future<Result<R>> mapAsync<R>(Future<R> Function(T) transform) async {
    final result = await this;
    return switch (result) {
      Success<T>(data: final data) => Success(await transform(data)),
      Error<T>(error: final error) => Error(error),
    };
  }

  /// Chain async operations
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Success<T>(data: final data) => await transform(data),
      Error<T>(error: final error) => Error(error),
    };
  }

  /// Handle errors and convert to result
  Future<Result<T>> catchError() async {
    try {
      return await this;
    } catch (error, stackTrace) {
      return Error(ErrorFactory.fromException(error, stackTrace));
    }
  }
}

/// Helper functions
class ResultHelpers {
  /// Create success result
  static Result<T> success<T>(T data) => Success(data);

  /// Create error result
  static Result<T> error<T>(AppError error) => Error(error);

  /// Combine multiple results
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final data = <T>[];
    for (final result in results) {
      switch (result) {
        case Success<T>(data: final value):
          data.add(value);
        case Error<T>(error: final error):
          return Error(error);
      }
    }
    return Success(data);
  }

  /// Execute async function and wrap in result
  static Future<Result<T>> tryAsync<T>(
    Future<T> Function() operation,
  ) async {
    try {
      final result = await operation();
      return Success(result);
    } catch (error, stackTrace) {
      return Error(ErrorFactory.fromException(error, stackTrace));
    }
  }

  /// Execute sync function and wrap in result
  static Result<T> trySync<T>(T Function() operation) {
    try {
      final result = operation();
      return Success(result);
    } catch (error, stackTrace) {
      return Error(ErrorFactory.fromException(error, stackTrace));
    }
  }
}
