/// API Connection Helper Utility
///
/// This utility provides easy-to-use methods for testing and diagnosing
/// API connectivity issues. Use this to verify your backend setup.
///
/// Usage:
/// ```dart
/// final helper = ApiConnectionHelper();
/// await helper.runFullDiagnostic();
/// ```

import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../../data/services/emotion_api_service.dart';

/// Helper class for API connection testing and diagnostics
class ApiConnectionHelper {
  static const String _logPrefix = '[API Helper]';

  final EmotionApiService _apiService = EmotionApiService();

  /// Run a comprehensive diagnostic test
  ///
  /// This method tests all aspects of the API connection and provides
  /// detailed feedback for troubleshooting.
  Future<ConnectionDiagnostic> runFullDiagnostic() async {
    print('$_logPrefix Starting API diagnostic...');
    print('$_logPrefix Target URL: ${AppConfig.baseUrl}');
    print('$_logPrefix ========================================');

    final diagnostic = ConnectionDiagnostic();

    // 1. Basic connectivity test
    diagnostic.basicConnectivity = await _testBasicConnectivity();

    // 2. Health endpoint test
    diagnostic.healthEndpoint = await _testHealthEndpoint();

    // 3. Prediction endpoint test
    diagnostic.predictionEndpoint = await _testPredictionEndpoint();

    // 4. Network diagnostics
    diagnostic.networkInfo = await _gatherNetworkInfo();

    // 5. Performance test
    diagnostic.performanceMetrics = await _testPerformance();

    // Print summary
    _printDiagnosticSummary(diagnostic);

    return diagnostic;
  }

  /// Quick connection test - returns true if backend is reachable
  Future<bool> quickConnectionTest() async {
    print('$_logPrefix Running quick connection test...');

    try {
      final isConnected = await _apiService.checkConnection();
      print('$_logPrefix Result: ${isConnected ? 'SUCCESS' : 'FAILED'}');
      return isConnected;
    } catch (e) {
      print('$_logPrefix Error: $e');
      return false;
    }
  }

  /// Test all API endpoints
  Future<Map<String, bool>> testAllEndpoints() async {
    print('$_logPrefix Testing all endpoints...');

    try {
      final results = await _apiService.testAllEndpoints();
      results.forEach((endpoint, success) {
        print('$_logPrefix $endpoint: ${success ? 'OK' : 'FAILED'}');
      });
      return results;
    } catch (e) {
      print('$_logPrefix Endpoint test error: $e');
      return {};
    }
  }

  /// Get detailed connection information
  Future<Map<String, dynamic>> getDetailedConnectionInfo() async {
    print('$_logPrefix Getting connection details...');

    try {
      final details = await _apiService.getConnectionDetails();
      print('$_logPrefix Details retrieved successfully');
      return details;
    } catch (e) {
      print('$_logPrefix Failed to get details: $e');
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Test network reachability to the configured server
  Future<NetworkReachabilityResult> testNetworkReachability() async {
    print('$_logPrefix Testing network reachability...');

    final result = NetworkReachabilityResult();
    final uri = Uri.parse(AppConfig.baseUrl);

    try {
      // Test DNS resolution
      result.dnsResolution = await _testDnsResolution(uri.host);

      // Test port connectivity
      result.portConnectivity = await _testPortConnectivity(uri.host, uri.port);

      // Test HTTP connectivity
      result.httpConnectivity = await _testHttpConnectivity();
    } catch (e) {
      result.error = e.toString();
    }

    return result;
  }

  /// Generate a connection troubleshooting report
  String generateTroubleshootingReport(ConnectionDiagnostic diagnostic) {
    final buffer = StringBuffer();

    buffer.writeln('API CONNECTION TROUBLESHOOTING REPORT');
    buffer.writeln('=====================================');
    buffer.writeln('Generated: ${DateTime.now()}');
    buffer.writeln('Target URL: ${AppConfig.baseUrl}');
    buffer.writeln('Mock Mode: ${_isInMockMode()}');
    buffer.writeln();

    // Basic connectivity
    buffer.writeln('CONNECTIVITY STATUS:');
    buffer.writeln(
      '- Basic connectivity: ${diagnostic.basicConnectivity ? 'OK' : 'FAILED'}',
    );
    buffer.writeln(
      '- Health endpoint: ${diagnostic.healthEndpoint ? 'OK' : 'FAILED'}',
    );
    buffer.writeln(
      '- Prediction endpoint: ${diagnostic.predictionEndpoint ? 'OK' : 'FAILED'}',
    );
    buffer.writeln();

    // Network info
    if (diagnostic.networkInfo.isNotEmpty) {
      buffer.writeln('NETWORK INFORMATION:');
      diagnostic.networkInfo.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
      buffer.writeln();
    }

    // Performance metrics
    if (diagnostic.performanceMetrics.isNotEmpty) {
      buffer.writeln('PERFORMANCE METRICS:');
      diagnostic.performanceMetrics.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
      buffer.writeln();
    }

    // Recommendations
    buffer.writeln('RECOMMENDATIONS:');
    if (!diagnostic.basicConnectivity) {
      buffer.writeln('- Check if backend server is running');
      buffer.writeln('- Verify the server URL in app_config.dart');
      buffer.writeln('- Check firewall and network settings');
    }
    if (!diagnostic.healthEndpoint) {
      buffer.writeln('- Verify /health endpoint is implemented');
      buffer.writeln('- Check server logs for errors');
    }
    if (!diagnostic.predictionEndpoint) {
      buffer.writeln('- Verify /predict endpoint is implemented');
      buffer.writeln('- Check request/response format');
    }

    return buffer.toString();
  }

  // =============================================================================
  // PRIVATE HELPER METHODS
  // =============================================================================

  Future<bool> _testBasicConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/health'))
          .timeout(const Duration(seconds: 10));

      final isConnected = response.statusCode == 200;
      print(
        '$_logPrefix Basic connectivity: ${isConnected ? 'OK' : 'FAILED'} (${response.statusCode})',
      );
      return isConnected;
    } catch (e) {
      print('$_logPrefix Basic connectivity failed: $e');
      return false;
    }
  }

  Future<bool> _testHealthEndpoint() async {
    try {
      final isHealthy = await _apiService.checkConnection();
      print('$_logPrefix Health endpoint: ${isHealthy ? 'OK' : 'FAILED'}');
      return isHealthy;
    } catch (e) {
      print('$_logPrefix Health endpoint error: $e');
      return false;
    }
  }

  Future<bool> _testPredictionEndpoint() async {
    try {
      final result = await _apiService.predictEmotion('test connection');
      final isWorking = result.emotion.isNotEmpty;
      print('$_logPrefix Prediction endpoint: ${isWorking ? 'OK' : 'FAILED'}');
      return isWorking;
    } catch (e) {
      print('$_logPrefix Prediction endpoint error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> _gatherNetworkInfo() async {
    final info = <String, dynamic>{};

    try {
      // Get configured URL details
      final uri = Uri.parse(AppConfig.baseUrl);
      info['configured_host'] = uri.host;
      info['configured_port'] = uri.port;
      info['configured_scheme'] = uri.scheme;

      // Test connectivity details
      final details = await _apiService.getConnectionDetails();
      info.addAll(details);
    } catch (e) {
      info['error'] = e.toString();
    }

    return info;
  }

  Future<Map<String, dynamic>> _testPerformance() async {
    final metrics = <String, dynamic>{};

    try {
      // Test response time
      final startTime = DateTime.now();
      await _apiService.checkConnection();
      final responseTime = DateTime.now().difference(startTime).inMilliseconds;

      metrics['response_time_ms'] = responseTime;
      metrics['response_time_rating'] = _getRatingForResponseTime(responseTime);

      // Get API service performance stats
      final apiStats = _apiService.getPerformanceStats();
      metrics.addAll(apiStats);
    } catch (e) {
      metrics['performance_test_error'] = e.toString();
    }

    return metrics;
  }

  Future<bool> _testDnsResolution(String hostname) async {
    try {
      final addresses = await InternetAddress.lookup(hostname);
      return addresses.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _testPortConnectivity(String hostname, int port) async {
    try {
      final socket = await Socket.connect(
        hostname,
        port,
        timeout: const Duration(seconds: 5),
      );
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _testHttpConnectivity() async {
    try {
      final response = await http
          .get(Uri.parse(AppConfig.baseUrl))
          .timeout(const Duration(seconds: 10));

      return response.statusCode < 500; // Accept any non-server-error response
    } catch (e) {
      return false;
    }
  }

  bool _isInMockMode() {
    // This would need to be adjusted based on how mock mode is configured
    return AppConfig.baseUrl.contains('mock') ||
        AppConfig.baseUrl.contains('localhost');
  }

  String _getRatingForResponseTime(int milliseconds) {
    if (milliseconds < 100) return 'Excellent';
    if (milliseconds < 300) return 'Good';
    if (milliseconds < 1000) return 'Fair';
    return 'Poor';
  }

  void _printDiagnosticSummary(ConnectionDiagnostic diagnostic) {
    print('$_logPrefix ========================================');
    print('$_logPrefix DIAGNOSTIC SUMMARY:');
    print(
      '$_logPrefix - Basic connectivity: ${diagnostic.basicConnectivity ? 'OK' : 'FAILED'}',
    );
    print(
      '$_logPrefix - Health endpoint: ${diagnostic.healthEndpoint ? 'OK' : 'FAILED'}',
    );
    print(
      '$_logPrefix - Prediction endpoint: ${diagnostic.predictionEndpoint ? 'OK' : 'FAILED'}',
    );

    if (diagnostic.performanceMetrics.containsKey('response_time_ms')) {
      print(
        '$_logPrefix - Response time: ${diagnostic.performanceMetrics['response_time_ms']}ms '
        '(${diagnostic.performanceMetrics['response_time_rating']})',
      );
    }

    final overallStatus =
        diagnostic.basicConnectivity &&
        diagnostic.healthEndpoint &&
        diagnostic.predictionEndpoint;

    print(
      '$_logPrefix - Overall status: ${overallStatus ? 'READY' : 'NEEDS ATTENTION'}',
    );
    print('$_logPrefix ========================================');
  }

  /// Clean up resources
  void dispose() {
    _apiService.dispose();
  }
}

/// Represents the result of a comprehensive connection diagnostic
class ConnectionDiagnostic {
  bool basicConnectivity = false;
  bool healthEndpoint = false;
  bool predictionEndpoint = false;
  Map<String, dynamic> networkInfo = {};
  Map<String, dynamic> performanceMetrics = {};
}

/// Represents the result of testing a specific API endpoint
class EndpointTestResult {
  final String name;
  final String path;
  bool success = false;
  int? statusCode;
  int? responseTime;
  String? error;
  Map<String, dynamic>? responseData;

  EndpointTestResult({required this.name, required this.path});
}

/// Represents network reachability test results
class NetworkReachabilityResult {
  bool dnsResolution = false;
  bool portConnectivity = false;
  bool httpConnectivity = false;
  String? error;

  bool get isFullyReachable =>
      dnsResolution && portConnectivity && httpConnectivity;
}
