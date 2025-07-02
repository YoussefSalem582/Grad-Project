// Simplified dependency injection without external packages
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  static ServiceLocator get instance => _instance;

  final Map<Type, dynamic> _services = {};

  void registerLazySingleton<T>(T Function() factory) {
    _services[T] = factory;
  }

  void registerFactory<T>(T Function() factory) {
    _services[T] = factory;
  }

  T call<T>() {
    final factory = _services[T];
    if (factory == null) {
      throw Exception('Service of type $T is not registered');
    }
    if (factory is T Function()) {
      return factory();
    }
    return factory as T;
  }
}

final sl = ServiceLocator.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // For now, we'll initialize the providers directly in the UI
  // This avoids circular dependency issues
}
