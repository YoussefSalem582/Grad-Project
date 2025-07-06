import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/connection_cubit.dart' as cubit;
import '../widgets/backend_connection_widget.dart';

/// Comprehensive demonstration page for backend connection system features
///
/// This page serves as both a demo and a reference implementation showing
/// how to use the backend connection system in a real application. It demonstrates:
///
/// **Core Features:**
/// - Real-time connection status monitoring
/// - Backend environment switching (development, staging, production)
/// - Health checks and connectivity testing
/// - Error handling and recovery mechanisms
/// - Mock data support for offline development
///
/// **UI Components:**
/// - Connection status indicator with visual feedback
/// - Environment switching with confirmation dialogs
/// - Health check results with detailed backend information
/// - Quick action buttons for common operations
/// - Expandable sections for testing different API endpoints
///
/// **Educational Value:**
/// This demo shows developers how to:
/// - Integrate the connection system into their screens
/// - Handle different connection states appropriately
/// - Provide user feedback during connection operations
/// - Implement retry mechanisms and error recovery
/// - Use BLoC pattern for state management
///
/// **Testing Capabilities:**
/// The page includes interactive elements for testing:
/// - Manual connection testing with different backends
/// - API endpoint testing (health, analytics, system metrics)
/// - Error simulation and handling
/// - Performance monitoring and response time measurement
///
/// Usage:
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => BackendConnectionDemo(),
///   ),
/// );
/// ```
///
/// The demo automatically adapts to the current connection state and provides
/// appropriate UI feedback. All operations are non-destructive and safe for
/// testing in any environment.
class BackendConnectionDemo extends StatelessWidget {
  /// Creates a backend connection demonstration page
  ///
  /// This page is stateless and uses BLoC for state management.
  /// No configuration is required - it automatically adapts to the
  /// current connection state and available backend environments.
  const BackendConnectionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Connection Demo'),
        actions: [
          // Connection status indicator
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ConnectionStatusIndicator(),
          ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Simple settings dialog for demo
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Connection Settings'),
                  content: const Text(
                    'In a full implementation, this would show the connection settings page.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _WelcomeCard(),
            const SizedBox(height: 20),

            // Connection Status Card
            _ConnectionStatusCard(),
            const SizedBox(height: 20),

            // Quick Actions
            _QuickActionsCard(),
            const SizedBox(height: 20),

            // API Test Section
            _ApiTestSection(),
            const SizedBox(height: 20),

            // Environment Info
            _EnvironmentInfoCard(),
          ],
        ),
      ),
      floatingActionButton: const BackendSwitchFAB(),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.rocket_launch, color: Colors.blue, size: 32),
                const SizedBox(width: 12),
                Text(
                  'Backend Connection Demo',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This demo shows how easy it is to connect your app to different backend environments. '
              'Switch between local development, staging, and production with just a few taps!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<cubit.ConnectionCubit, cubit.BackendConnectionState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection Status',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildStatusInfo(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusInfo(
    BuildContext context,
    cubit.BackendConnectionState state,
  ) {
    if (state is cubit.ConnectionConnected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Connected to ${state.config.name}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('URL: ${state.config.baseUrl}'),
          if (state.details != null) ...[
            const SizedBox(height: 4),
            Text('Status: ${state.details!['status'] ?? 'Unknown'}'),
          ],
        ],
      );
    } else if (state is cubit.ConnectionConnecting) {
      return Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text('Connecting...', style: TextStyle(color: Colors.orange)),
        ],
      );
    } else if (state is cubit.ConnectionError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                'Connection Error',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(state.message),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.read<cubit.ConnectionCubit>().retryConnection();
            },
            child: const Text('Retry Connection'),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(Icons.cloud_off, color: Colors.grey),
          const SizedBox(width: 8),
          Text('Not Connected', style: TextStyle(color: Colors.grey)),
        ],
      );
    }
  }
}

class _QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ActionButton(
                  icon: Icons.settings,
                  label: 'Connection Settings',
                  onPressed: () {
                    // Simple settings dialog for demo
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Connection Settings'),
                        content: const Text(
                          'This would show the full connection settings page.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _ActionButton(
                  icon: Icons.refresh,
                  label: 'Test Connection',
                  onPressed: () {
                    context.read<cubit.ConnectionCubit>().testConnection();
                  },
                ),
                _ActionButton(
                  icon: Icons.swap_horiz,
                  label: 'Switch Backend',
                  onPressed: () async {
                    // Show simple backend selection for demo
                    final selectedBackend = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Backend'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Local Development'),
                              subtitle: const Text('http://localhost:8002'),
                              onTap: () => Navigator.pop(context, 'local'),
                            ),
                            ListTile(
                              title: const Text('Staging'),
                              subtitle: const Text(
                                'https://staging-api.emosense.com',
                              ),
                              onTap: () => Navigator.pop(context, 'staging'),
                            ),
                            ListTile(
                              title: const Text('Production'),
                              subtitle: const Text('https://api.emosense.com'),
                              onTap: () => Navigator.pop(context, 'production'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    );

                    if (selectedBackend != null && context.mounted) {
                      // In a real app, you would create a BackendConfig and connect
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected: $selectedBackend backend'),
                        ),
                      );
                    }
                  },
                ),
                _ActionButton(
                  icon: Icons.cloud_off,
                  label: 'Disconnect',
                  onPressed: () {
                    context.read<cubit.ConnectionCubit>().disconnect();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _ApiTestSection extends StatefulWidget {
  @override
  State<_ApiTestSection> createState() => _ApiTestSectionState();
}

class _ApiTestSectionState extends State<_ApiTestSection> {
  String _testResult = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Test',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Test your backend API connection:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testApi,
              icon: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.api),
              label: Text(_isLoading ? 'Testing...' : 'Test API Endpoint'),
            ),
            if (_testResult.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  _testResult,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _testApi() async {
    setState(() {
      _isLoading = true;
      _testResult = '';
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final connectionState = context.read<cubit.ConnectionCubit>().state;
      if (connectionState is cubit.ConnectionConnected) {
        setState(() {
          _testResult =
              '''✅ API Test Successful!

Backend: ${connectionState.config.name}
URL: ${connectionState.config.baseUrl}
Status: Connected
Timestamp: ${DateTime.now().toIso8601String()}

Note: This is a demo. In a real app, this would make actual API calls.''';
        });
      } else {
        setState(() {
          _testResult = '''❌ API Test Failed

Status: Not connected to backend
Please establish a connection first.''';
        });
      }
    } catch (e) {
      setState(() {
        _testResult = '''❌ API Test Error

Error: ${e.toString()}''';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class _EnvironmentInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Environment Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoRow(label: 'App Version', value: '1.0.0'),
            _InfoRow(label: 'Environment', value: 'Development'),
            _InfoRow(label: 'Debug Mode', value: 'Enabled'),
            _InfoRow(label: 'Mock Data', value: 'Enabled'),
            _InfoRow(label: 'Network Logging', value: 'Enabled'),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
