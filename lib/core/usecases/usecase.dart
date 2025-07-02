import '../errors/failures.dart';

/// Type alias for Either pattern (success or failure)
typedef Either<L, R> = ({L? left, R? right});

/// Helper functions for Either pattern
extension EitherExtension<L, R> on Either<L, R> {
  bool get isLeft => left != null;
  bool get isRight => right != null;

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    if (isLeft) return leftFn(left as L);
    return rightFn(right as R);
  }
}

/// Helper functions to create Either instances
Either<L, R> Left<L, R>(L value) => (left: value, right: null);
Either<L, R> Right<L, R>(R value) => (left: null, right: value);

/// Base interface for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case without parameters
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}
