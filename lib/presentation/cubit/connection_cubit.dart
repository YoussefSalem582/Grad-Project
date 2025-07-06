import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../core/network/connection_manager.dart';

/// Base class for all connection-related states
///
/// Uses Equatable to enable state comparison in BLoC,
/// which is essential for UI updates when state changes.
abstract class BackendConnectionState extends Equatable {
  const BackendConnectionState();

  @override
  List<Object?> get props => [];
}

/// Initial state when the connection cubit is first created
///
/// This state indicates that no connection attempt has been made yet.
class ConnectionInitial extends BackendConnectionState {}

/// State indicating a connection attempt is in progress
///
/// UI can show loading indicators when in this state.
class ConnectionConnecting extends BackendConnectionState {}

/// State indicating successful connection to a backend
///
/// Contains the active configuration and optional connection details
/// such as response times, server version, etc.
class ConnectionConnected extends BackendConnectionState {
  /// The backend configuration that is currently connected
  final BackendConfig config;

  /// Optional additional details about the connection
  /// May include server info, response times, capabilities, etc.
  final Map<String, dynamic>? details;

  const ConnectionConnected({required this.config, this.details});

  @override
  List<Object?> get props => [config, details];
}

/// State indicating no active backend connection
///
/// This is different from ConnectionInitial as it indicates
/// a deliberate disconnection or failed connection attempt.
class ConnectionDisconnected extends BackendConnectionState {}

/// State indicating a connection error occurred
///
/// Contains error details that can be displayed to the user
/// and used for debugging and recovery strategies.
class ConnectionError extends BackendConnectionState {
  /// Human-readable error message
  final String message;

  /// Optional exception details for debugging
  final Exception? exception;

  const ConnectionError({required this.message, this.exception});

  @override
  List<Object?> get props => [message, exception];
}

/// Cubit for managing backend connections
class ConnectionCubit extends Cubit<BackendConnectionState> {
  final ConnectionManager _connectionManager = ConnectionManager.instance;
  StreamSubscription? _statusSubscription;
  BackendConfig? _lastConfig;

  ConnectionCubit() : super(ConnectionInitial());

  /// Initialize the connection cubit
  Future<void> initialize() async {
    try {
      await _connectionManager.initialize();

      // Listen to connection status changes
      _statusSubscription = _connectionManager.statusStream.listen((status) {
        switch (status) {
          case ConnectionStatus.connecting:
            emit(ConnectionConnecting());
            break;
          case ConnectionStatus.connected:
            if (_connectionManager.currentConfig != null) {
              emit(
                ConnectionConnected(
                  config: _connectionManager.currentConfig!,
                  details: _connectionManager.getConnectionDetails(),
                ),
              );
            }
            break;
          case ConnectionStatus.disconnected:
            emit(ConnectionDisconnected());
            break;
          case ConnectionStatus.error:
            emit(ConnectionError(message: 'Connection error occurred'));
            break;
        }
      });

      // Try to connect using environment configuration
      await connectUsingEnvironment();
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Failed to initialize connection: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Connect using environment configuration
  Future<void> connectUsingEnvironment() async {
    emit(ConnectionConnecting());

    try {
      final result = await _connectionManager.connectUsingEnvironment();

      if (!result.success) {
        emit(ConnectionError(message: result.message, exception: result.error));
      }
      // Success state will be handled by the status stream listener
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Failed to connect: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Connect to a specific backend configuration
  Future<void> connectToBackend(BackendConfig config) async {
    emit(ConnectionConnecting());
    _lastConfig = config;

    try {
      final result = await _connectionManager.connectToBackend(config);

      if (!result.success) {
        emit(ConnectionError(message: result.message, exception: result.error));
      }
      // Success state will be handled by the status stream listener
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Failed to connect to ${config.name}: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Test current connection
  Future<void> testConnection() async {
    try {
      final result = await _connectionManager.testConnection();

      if (result.success) {
        if (_connectionManager.currentConfig != null) {
          emit(
            ConnectionConnected(
              config: _connectionManager.currentConfig!,
              details: result.data,
            ),
          );
        }
      } else {
        emit(ConnectionError(message: result.message, exception: result.error));
      }
    } catch (e) {
      emit(
        ConnectionError(
          message: 'Connection test failed: ${e.toString()}',
          exception: e is Exception ? e : Exception(e.toString()),
        ),
      );
    }
  }

  /// Retry last connection
  Future<void> retryConnection() async {
    if (_lastConfig != null) {
      await connectToBackend(_lastConfig!);
    } else {
      await connectUsingEnvironment();
    }
  }

  /// Disconnect from current backend
  void disconnect() {
    _connectionManager.disconnect();
    emit(ConnectionDisconnected());
  }

  /// Switch to a different backend
  Future<void> switchBackend(BackendConfig config) async {
    disconnect();
    await connectToBackend(config);
  }

  /// Get available backend configurations
  List<BackendConfig> get availableConfigs =>
      _connectionManager.predefinedConfigs;

  /// Get current connection details
  Map<String, dynamic> get connectionDetails =>
      _connectionManager.getConnectionDetails();

  /// Check if currently connected
  bool get isConnected => _connectionManager.isConnected;

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
