// Flutter API Configuration for Localhost Backend
// lib/core/config/api_config.dart

import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiConfig {
  // Localhost backend configuration
  static const String _localhostPort = '8000';

  // Get the appropriate base URL based on platform
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web - can access localhost directly
      return 'http://localhost:$_localhostPort';
    } else if (Platform.isAndroid) {
      // Android emulator uses special IP to access host localhost
      return 'http://10.0.2.2:$_localhostPort';
    } else if (Platform.isIOS) {
      // iOS simulator can access localhost directly
      return 'http://localhost:$_localhostPort';
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Desktop platforms can access localhost directly
      return 'http://localhost:$_localhostPort';
    } else {
      // Fallback for other platforms
      return 'http://localhost:$_localhostPort';
    }
  }

  // Alternative: Use your computer's IP address for physical devices
  static String get localNetworkUrl {
    // Replace with your computer's actual IP address
    return 'http://192.168.1.100:$_localhostPort'; // Example IP
  }

  // API endpoints
  static String get healthEndpoint => '$baseUrl/health';
  static String get textAnalysisEndpoint => '$baseUrl/analyze/text';
  static String get audioAnalysisEndpoint => '$baseUrl/analyze/audio';
  static String get videoAnalysisEndpoint => '$baseUrl/analyze/video';
  static String get batchAnalysisEndpoint => '$baseUrl/analyze/batch';
  static String get modelStatusEndpoint => '$baseUrl/models/status';
}

// Usage example in your API service
class EmotionApiService {
  Future<Map<String, dynamic>> analyzeText(String text) async {
    final response = await http.post(
      Uri.parse(ApiConfig.textAnalysisEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': text}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to analyze text: ${response.statusCode}');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.healthEndpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }
}
