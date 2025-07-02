import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message) : super(message);
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure(String message) : super(message);
}

/// File system failures
class FileSystemFailure extends Failure {
  const FileSystemFailure(super.message);
}

/// Unknown/unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
