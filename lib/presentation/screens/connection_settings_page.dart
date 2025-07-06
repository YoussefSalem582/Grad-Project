import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/connection_cubit.dart';
import '../widgets/backend_connection_widget.dart';
import '../../core/network/connection_manager.dart';

/// Comprehensive backend connection settings and management page
///
/// This page provides a user interface for managing backend connections with:
/// - Real-time connection status monitoring
/// - Backend environment switching (dev, staging, production)
/// - Connection testing and health checks
/// - Configuration management and persistence
/// - Error handling and user feedback
///
/// The page is organized into several key sections:
///
/// 1. **Connection Status Card**: Shows current connection state, response times,
///    server information, and quick actions for testing/refreshing connection.
///
/// 2. **Current Configuration Card**: Displays details about the active backend
///    including URL, environment, version, and connection metadata.
///
/// 3. **Available Backends List**: Shows all configured backend environments
///    with the ability to switch between them, test individual connections,
///    and view configuration details.
///
/// Key Features:
/// - One-tap backend switching with automatic reconnection
/// - Real-time connection status updates via BLoC state management
/// - Comprehensive error handling with user-friendly messages
/// - Connection health monitoring and testing capabilities
/// - Persistent backend selection across app restarts
///
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => ConnectionSettingsPage(),
///   ),
/// );
/// ```
///
/// The page automatically subscribes to connection state changes and updates
/// the UI accordingly. All connection operations are performed asynchronously
/// with appropriate loading states and error handling.
class ConnectionSettingsPage extends StatelessWidget {
  /// Creates a connection settings page
  ///
  /// This page is stateless and rebuilds based on connection state changes
  /// managed by the ConnectionCubit. No parameters are required as all
  /// state is managed through the BLoC pattern.
  const ConnectionSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ConnectionCubit>().testConnection();
            },
            tooltip: 'Test Connection',
          ),
        ],
      ),
      body: BlocBuilder<ConnectionCubit, BackendConnectionState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection Status Card
                _ConnectionStatusCard(),
                const SizedBox(height: 20),

                // Current Configuration
                _CurrentConfigurationCard(),
                const SizedBox(height: 20),

                // Available Configurations
                Text(
                  'Available Backends',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 12),
                Expanded(child: _BackendConfigurationsList()),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomBackendDialog(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Custom Backend',
      ),
    );
  }

  void _showAddCustomBackendDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const BackendSelectionDialog(),
    ).then((config) {
      if (config != null && context.mounted) {
        context.read<ConnectionCubit>().connectToBackend(config);
      }
    });
  }
}

class _ConnectionStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, BackendConnectionState>(
      builder: (context, state) {
        Color cardColor;
        IconData statusIcon;
        String statusText;
        String statusDescription;

        switch (state.runtimeType) {
          case ConnectionConnected:
            cardColor = Colors.green.shade50;
            statusIcon = Icons.check_circle;
            statusText = 'Connected';
            statusDescription = 'Backend is responding normally';
            break;
          case ConnectionConnecting:
            cardColor = Colors.orange.shade50;
            statusIcon = Icons.sync;
            statusText = 'Connecting...';
            statusDescription = 'Establishing connection to backend';
            break;
          case ConnectionError:
            final errorState = state as ConnectionError;
            cardColor = Colors.red.shade50;
            statusIcon = Icons.error;
            statusText = 'Connection Error';
            statusDescription = errorState.message;
            break;
          default:
            cardColor = Colors.grey.shade50;
            statusIcon = Icons.cloud_off;
            statusText = 'Disconnected';
            statusDescription = 'No backend connection';
        }

        return Card(
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(statusIcon, size: 32, color: _getStatusColor(state)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getStatusColor(state),
                            ),
                      ),
                      Text(
                        statusDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                if (state is ConnectionError)
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConnectionCubit>().retryConnection();
                    },
                    child: const Text('Retry'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(BackendConnectionState state) {
    switch (state.runtimeType) {
      case ConnectionConnected:
        return Colors.green;
      case ConnectionConnecting:
        return Colors.orange;
      case ConnectionError:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _CurrentConfigurationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, BackendConnectionState>(
      builder: (context, state) {
        final connectionManager = ConnectionManager.instance;
        final currentConfig = connectionManager.currentConfig;

        if (currentConfig == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Configuration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('No backend configuration selected'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ConnectionCubit>().connectUsingEnvironment();
                    },
                    child: const Text('Connect to Default'),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Current Configuration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.read<ConnectionCubit>().disconnect();
                      },
                      child: const Text('Disconnect'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _ConfigurationInfo(config: currentConfig),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BackendConfigurationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, BackendConnectionState>(
      builder: (context, state) {
        final availableConfigs = context
            .read<ConnectionCubit>()
            .availableConfigs;
        final currentConfig = ConnectionManager.instance.currentConfig;

        return ListView.builder(
          itemCount: availableConfigs.length,
          itemBuilder: (context, index) {
            final config = availableConfigs[index];
            final isCurrentConfig =
                currentConfig?.name == config.name &&
                currentConfig?.baseUrl == config.baseUrl;

            return Card(
              color: isCurrentConfig ? Colors.blue.shade50 : null,
              child: ListTile(
                leading: Icon(
                  config.isDefault ? Icons.star : Icons.cloud,
                  color: config.isDefault ? Colors.amber : null,
                ),
                title: Text(
                  config.name,
                  style: TextStyle(
                    fontWeight: isCurrentConfig ? FontWeight.bold : null,
                    color: isCurrentConfig ? Colors.blue : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(config.baseUrl),
                    if (isCurrentConfig)
                      Text(
                        'Currently Connected',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                trailing: isCurrentConfig
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : IconButton(
                        icon: const Icon(Icons.connect_without_contact),
                        onPressed: state is ConnectionConnecting
                            ? null
                            : () {
                                context
                                    .read<ConnectionCubit>()
                                    .connectToBackend(config);
                              },
                      ),
                onTap: isCurrentConfig || state is ConnectionConnecting
                    ? null
                    : () {
                        context.read<ConnectionCubit>().connectToBackend(
                          config,
                        );
                      },
              ),
            );
          },
        );
      },
    );
  }
}

class _ConfigurationInfo extends StatelessWidget {
  final BackendConfig config;

  const _ConfigurationInfo({required this.config});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(label: 'Name', value: config.name),
        _InfoRow(label: 'URL', value: config.baseUrl),
        _InfoRow(label: 'API Key', value: _maskApiKey(config.apiKey)),
        if (config.isDefault)
          _InfoRow(label: 'Type', value: 'Default Configuration'),
      ],
    );
  }

  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return '*' * apiKey.length;
    return '${apiKey.substring(0, 4)}${'*' * (apiKey.length - 8)}${apiKey.substring(apiKey.length - 4)}';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
