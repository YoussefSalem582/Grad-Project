import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/connection_cubit.dart' as cubit;
import '../widgets/backend_connection_widget.dart';
import '../../core/network/connection_manager.dart';

/// Settings page for managing backend connections
class ConnectionSettingsPage extends StatelessWidget {
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
              context.read<cubit.ConnectionCubit>().testConnection();
            },
            tooltip: 'Test Connection',
          ),
        ],
      ),
      body: BlocBuilder<cubit.ConnectionCubit, cubit.BackendConnectionState>(
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
        context.read<cubit.ConnectionCubit>().connectToBackend(config);
      }
    });
  }
}

class _ConnectionStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.ConnectionCubit, cubit.BackendConnectionState>(
      builder: (context, state) {
        Color cardColor;
        IconData statusIcon;
        String statusText;
        String statusDescription;

        if (state is cubit.ConnectionConnected) {
          cardColor = Colors.green.shade50;
          statusIcon = Icons.check_circle;
          statusText = 'Connected';
          statusDescription = 'Backend is responding normally';
        } else if (state is cubit.ConnectionConnecting) {
          cardColor = Colors.orange.shade50;
          statusIcon = Icons.sync;
          statusText = 'Connecting...';
          statusDescription = 'Establishing connection to backend';
        } else if (state is cubit.ConnectionError) {
          cardColor = Colors.red.shade50;
          statusIcon = Icons.error;
          statusText = 'Connection Error';
          statusDescription = state.message;
        } else {
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
                if (state is cubit.ConnectionError)
                  ElevatedButton(
                    onPressed: () {
                      context.read<cubit.ConnectionCubit>().retryConnection();
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

  Color _getStatusColor(cubit.BackendConnectionState state) {
    if (state is cubit.ConnectionConnected) {
      return Colors.green;
    } else if (state is cubit.ConnectionConnecting) {
      return Colors.orange;
    } else if (state is cubit.ConnectionError) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }
}

class _CurrentConfigurationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.ConnectionCubit, cubit.BackendConnectionState>(
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
                      context
                          .read<cubit.ConnectionCubit>()
                          .connectUsingEnvironment();
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
                        context.read<cubit.ConnectionCubit>().disconnect();
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
    return BlocBuilder<cubit.ConnectionCubit, cubit.BackendConnectionState>(
      builder: (context, state) {
        final availableConfigs = context
            .read<cubit.ConnectionCubit>()
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
                        onPressed: state is cubit.ConnectionConnecting
                            ? null
                            : () {
                                context
                                    .read<cubit.ConnectionCubit>()
                                    .connectToBackend(config);
                              },
                      ),
                onTap: isCurrentConfig || state is cubit.ConnectionConnecting
                    ? null
                    : () {
                        context.read<cubit.ConnectionCubit>().connectToBackend(
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
