import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface for checking network connectivity status
///
/// This abstract class defines the contract for network connectivity checking
/// within the backend connection system. It provides methods to:
/// - Check current connectivity status
/// - Monitor connectivity changes in real-time
///
/// Implementation classes should handle platform-specific connectivity
/// detection and provide reliable network status information for the
/// backend connection management system.
///
/// Usage:
/// ```dart
/// final networkInfo = NetworkInfoImpl();
///
/// // Check current connectivity
/// final isConnected = await networkInfo.isConnected;
///
/// // Listen to connectivity changes
/// networkInfo.connectivityStream.listen((results) {
///   print('Connectivity changed: $results');
/// });
/// ```
abstract class NetworkInfo {
  /// Checks if the device is currently connected to the internet
  ///
  /// Returns true if connected via mobile, WiFi, Ethernet, or VPN.
  /// Returns false if disconnected or if an error occurs during checking.
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  ///
  /// Emits a list of ConnectivityResult whenever the device's
  /// connectivity status changes. This allows real-time monitoring
  /// of network status for the backend connection system.
  Stream<List<ConnectivityResult>> get connectivityStream;
}

/// Implementation of NetworkInfo using connectivity_plus package
///
/// This class provides concrete implementation for network connectivity
/// checking using the connectivity_plus package. It handles:
///
/// **Connectivity Detection:**
/// - Mobile data connections
/// - WiFi connections
/// - Ethernet connections
/// - VPN connections
///
/// **Real-time Monitoring:**
/// - Continuous monitoring of connectivity changes
/// - Stream-based updates for reactive UI components
/// - Automatic reconnection detection
///
/// **Error Handling:**
/// - Graceful handling of connectivity check failures
/// - Fallback to disconnected state on errors
/// - Safe async operations with try-catch blocks
///
/// The implementation is designed to be reliable and performant,
/// suitable for use in production applications where network
/// connectivity is critical for backend operations.
///
/// Example usage:
/// ```dart
/// final networkInfo = NetworkInfoImpl();
///
/// // Check connectivity before making API calls
/// if (await networkInfo.isConnected) {
///   // Safe to make network requests
///   await apiClient.get('/data');
/// } else {
///   // Handle offline state
///   showOfflineMessage();
/// }
/// ```
class NetworkInfoImpl implements NetworkInfo {
  /// The connectivity_plus instance used for network checks
  ///
  /// This private field holds the Connectivity instance that provides
  /// the actual platform-specific connectivity checking functionality.
  final Connectivity _connectivity;

  /// Creates a NetworkInfoImpl instance with optional dependency injection
  ///
  /// Parameters:
  /// - [connectivity]: Optional Connectivity instance for testing/mocking.
  ///   If not provided, a default Connectivity() instance is used.
  ///
  /// This constructor pattern allows for easy testing by injecting mock
  /// connectivity instances while maintaining simplicity for production use.
  NetworkInfoImpl({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Checks if the device has an active internet connection
  ///
  /// This method performs a connectivity check to determine if the device
  /// is connected to the internet via any supported connection type:
  /// - Mobile data (cellular)
  /// - WiFi networks
  /// - Ethernet connections
  /// - VPN connections
  ///
  /// The method uses a try-catch block to handle any errors that might
  /// occur during the connectivity check, returning false in case of
  /// exceptions to ensure the application can handle offline states gracefully.
  ///
  /// Returns:
  /// - true: Device has an active internet connection
  /// - false: Device is offline or connectivity check failed
  ///
  /// Note: This method only checks for network interface availability,
  /// not actual internet reachability. For full internet connectivity
  /// verification, consider implementing additional HTTP-based checks.
  @override
  Future<bool> get isConnected async {
    try {
      final ConnectivityResult connectivityResult = await _connectivity
          .checkConnectivity();
      return connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn;
    } catch (e) {
      // Return false on any error to safely handle offline states
      return false;
    }
  }

  /// Stream of connectivity status changes
  ///
  /// This stream provides real-time updates whenever the device's network
  /// connectivity status changes. It's essential for reactive UI components
  /// that need to respond to network state changes immediately.
  ///
  /// The stream emits List[ConnectivityResult] to maintain compatibility
  /// with the NetworkInfo interface, even though the underlying connectivity
  /// stream returns single ConnectivityResult values.
  ///
  /// Use cases:
  /// - Update UI indicators when going online/offline
  /// - Trigger backend reconnection attempts
  /// - Cache data when connectivity is lost
  /// - Resume operations when connectivity is restored
  ///
  /// Example:
  /// ```dart
  /// networkInfo.connectivityStream.listen((results) {
  ///   final isOnline = results.any((result) =>
  ///     result != ConnectivityResult.none);
  ///   if (isOnline) {
  ///     resumeBackendOperations();
  ///   } else {
  ///     switchToOfflineMode();
  ///   }
  /// });
  /// ```
  @override
  Stream<List<ConnectivityResult>> get connectivityStream =>
      _connectivity.onConnectivityChanged.map((result) => [result]);
}
