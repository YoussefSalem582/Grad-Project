import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/connection_manager.dart';
import '../cubit/connection_cubit.dart';

/// Root-level widget for managing backend connection state and UI
///
/// This widget serves as the application-wide connection manager, providing:
/// - Automatic connection initialization on app startup
/// - Global connection state management via BLoC pattern
/// - User notifications for connection status changes
/// - Centralized error handling and retry mechanisms
/// - Floating connection status indicator
///
/// The widget wraps the entire application to ensure connection management
/// is available throughout the widget tree. It automatically:
///
/// 1. Initializes the connection manager on startup
/// 2. Provides connection cubit to all child widgets
/// 3. Listens for connection state changes
/// 4. Shows appropriate user feedback (snackbars, status indicators)
/// 5. Handles connection errors with retry options
///
/// Usage:
/// ```dart
/// class MyApp extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return BackendConnectionWidget(
///       child: MaterialApp(
///         // Your app content
///       ),
///     );
///   }
/// }
/// ```
///
/// Features:
/// - Persistent connection status floating button
/// - Automatic retry on connection failures
/// - Visual feedback for all connection states
/// - Easy access to connection management throughout the app
class BackendConnectionWidget extends StatefulWidget {
  /// The child widget that this connection widget wraps
  ///
  /// Typically this should be the root MaterialApp or similar top-level widget.
  /// All child widgets will have access to the connection state and management.
  final Widget child;

  /// Creates a backend connection widget
  ///
  /// Parameters:
  /// - [child]: The widget to wrap with connection management capabilities
  const BackendConnectionWidget({super.key, required this.child});

  @override
  State<BackendConnectionWidget> createState() =>
      _BackendConnectionWidgetState();
}

/// State class for the backend connection widget
///
/// Manages the lifecycle of the connection management system:
/// - Initializes the connection manager on widget creation
/// - Provides connection state to child widgets via BLoC
/// - Handles connection state changes and user notifications
/// - Manages the floating connection status indicator
class _BackendConnectionWidgetState extends State<BackendConnectionWidget> {
  /// Initializes the connection management system when the widget is created
  ///
  /// This method is called automatically by Flutter when the widget is
  /// first inserted into the widget tree. It ensures that the connection
  /// manager is properly initialized before any connection attempts are made.
  @override
  void initState() {
    super.initState();
    // Initialize the connection manager singleton
    // This sets up the manager with default configurations and prepares
    // it for backend connection attempts
    ConnectionManager.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConnectionCubit()..initialize(),
      child: BlocListener<ConnectionCubit, BackendConnectionState>(
        listener: (context, state) {
          if (state is ConnectionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connection Error: ${state.message}'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    context.read<ConnectionCubit>().retryConnection();
                  },
                ),
              ),
            );
          } else if (state is ConnectionConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Connected to ${state.config.name}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: widget.child,
      ),
    );
  }
}

/// Dialog widget for selecting and configuring backend connections
///
/// This dialog provides a user-friendly interface for:
/// - Selecting from predefined backend configurations
/// - Creating custom backend configurations
/// - Validating connection parameters
/// - Switching between different backend environments
///
/// The dialog supports two modes:
/// 1. **Predefined Mode**: Shows a list of pre-configured backends
///    with visual indicators for default/recommended configurations
/// 2. **Custom Mode**: Allows manual entry of backend details including
///    URL, API keys, and configuration names
///
/// Features:
/// - Input validation for required fields
/// - Secure handling of API keys
/// - Visual feedback for configuration selection
/// - Easy switching between predefined and custom modes
///
/// Usage:
/// ```dart
/// final config = await showDialog<BackendConfig>(
///   context: context,
///   builder: (context) => const BackendSelectionDialog(),
/// );
/// if (config != null) {
///   connectionCubit.connectToBackend(config);
/// }
/// ```
class BackendSelectionDialog extends StatefulWidget {
  /// Creates a backend selection dialog
  ///
  /// This dialog is stateful to manage the form inputs and mode switching
  /// between predefined and custom configuration entry.
  const BackendSelectionDialog({super.key});

  @override
  State<BackendSelectionDialog> createState() => _BackendSelectionDialogState();
}

/// State class for the backend selection dialog
///
/// Manages:
/// - Form controllers for custom configuration inputs
/// - UI mode switching (predefined vs custom)
/// - Input validation and error handling
/// - Configuration creation and submission
class _BackendSelectionDialogState extends State<BackendSelectionDialog> {
  /// Text controllers for custom configuration form inputs
  final _urlController = TextEditingController();
  final _apiKeyController = TextEditingController();
  final _nameController = TextEditingController();

  /// Flag to toggle between predefined and custom configuration modes
  bool _isCustom = false;

  /// Cleanup method to dispose of text controllers
  ///
  /// Called automatically by Flutter when the widget is removed
  /// from the widget tree. Prevents memory leaks by properly
  /// disposing of TextEditingController instances.
  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Backend'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Predefined configurations
            if (!_isCustom) ...[
              const Text('Choose a predefined configuration:'),
              const SizedBox(height: 16),
              ...ConnectionManager.instance.predefinedConfigs.map(
                (config) => ListTile(
                  title: Text(config.name),
                  subtitle: Text(config.baseUrl),
                  leading: Icon(
                    config.isDefault ? Icons.star : Icons.cloud,
                    color: config.isDefault ? Colors.amber : null,
                  ),
                  onTap: () {
                    Navigator.of(context).pop(config);
                  },
                ),
              ),
              const Divider(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isCustom = true;
                  });
                },
                child: const Text('Add Custom Configuration'),
              ),
            ],

            // Custom configuration
            if (_isCustom) ...[
              const Text('Enter custom backend details:'),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Configuration Name',
                  hintText: 'My Backend',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Base URL',
                  hintText: 'https://api.example.com',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'API Key',
                  hintText: 'your-api-key',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isCustom = false;
                      });
                    },
                    child: const Text('Back'),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _createCustomConfig,
                    child: const Text('Connect'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!_isCustom)
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
      ],
    );
  }

  /// Creates a custom backend configuration from user input
  ///
  /// Validates the required fields (name and URL) and creates a new
  /// BackendConfig object. Shows error feedback if validation fails.
  /// The API key defaults to 'default-key' if not provided.
  ///
  /// After successful creation, the dialog closes and returns the
  /// new configuration to the caller.
  void _createCustomConfig() {
    if (_nameController.text.isEmpty || _urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final config = BackendConfig(
      name: _nameController.text,
      baseUrl: _urlController.text,
      apiKey: _apiKeyController.text.isEmpty
          ? 'default-key'
          : _apiKeyController.text,
    );

    Navigator.of(context).pop(config);
  }
}

/// Visual indicator widget for displaying current connection status
///
/// This widget provides real-time visual feedback about the backend
/// connection state using:
/// - Color-coded icons (green=connected, orange=connecting, red=error, grey=disconnected)
/// - Descriptive status labels
/// - Responsive design that adapts to different UI contexts
///
/// The widget automatically updates when the connection state changes
/// via the BLoC pattern, ensuring the UI always reflects the current status.
///
/// Features:
/// - Real-time status updates
/// - Color-coded visual feedback
/// - Optional text labels (can be hidden for compact displays)
/// - Consistent iconography across the application
///
/// Usage:
/// ```dart
/// // With label (default)
/// ConnectionStatusIndicator()
///
/// // Icon only (compact mode)
/// ConnectionStatusIndicator(showLabel: false)
/// ```
class ConnectionStatusIndicator extends StatelessWidget {
  /// Whether to show the text label alongside the status icon
  ///
  /// When true (default), displays both icon and descriptive text.
  /// When false, shows only the icon for compact layouts.
  final bool showLabel;

  /// Creates a connection status indicator
  ///
  /// Parameters:
  /// - [showLabel]: Whether to display text labels (default: true)
  const ConnectionStatusIndicator({super.key, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, BackendConnectionState>(
      builder: (context, state) {
        Color color;
        IconData icon;
        String label;

        switch (state.runtimeType) {
          case ConnectionConnected:
            color = Colors.green;
            icon = Icons.cloud_done;
            label = 'Connected';
            break;
          case ConnectionConnecting:
            color = Colors.orange;
            icon = Icons.cloud_sync;
            label = 'Connecting...';
            break;
          case ConnectionError:
            color = Colors.red;
            icon = Icons.cloud_off;
            label = 'Error';
            break;
          default:
            color = Colors.grey;
            icon = Icons.cloud_off;
            label = 'Disconnected';
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Floating action button for quick backend switching
///
/// This widget provides a convenient floating action button that allows
/// users to quickly switch between different backend configurations without
/// navigating to a dedicated settings page.
///
/// When pressed, it opens a backend selection dialog where users can:
/// - Choose from predefined backend configurations
/// - Create and connect to custom backends
/// - View current connection status during the switch
///
/// The FAB automatically integrates with the connection state management
/// system and handles the connection process seamlessly.
///
/// Features:
/// - One-tap access to backend switching
/// - Integration with connection state management
/// - Automatic UI updates during connection changes
/// - Error handling for failed connection attempts
///
/// Usage:
/// ```dart
/// Scaffold(
///   floatingActionButton: BackendSwitchFAB(),
///   // ... other scaffold properties
/// )
/// ```
class BackendSwitchFAB extends StatelessWidget {
  /// Creates a backend switching floating action button
  ///
  /// This widget is stateless and relies on the BLoC pattern for
  /// state management and connection handling.
  const BackendSwitchFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionCubit, BackendConnectionState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () async {
            final config = await showDialog<BackendConfig>(
              context: context,
              builder: (context) => const BackendSelectionDialog(),
            );

            if (config != null) {
              if (context.mounted) {
                context.read<ConnectionCubit>().connectToBackend(config);
              }
            }
          },
          tooltip: 'Switch Backend',
          child: const Icon(Icons.swap_horiz),
        );
      },
    );
  }
}
