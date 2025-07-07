#!/usr/bin/env dart

/// Environment switcher script for EmoSense Flutter app
///
/// Usage:
///   dart scripts/switch_environment.dart development
///   dart scripts/switch_environment.dart production
///
/// This script copies the appropriate environment file to .env
/// so the app loads the correct configuration.

import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('❌ Error: Please specify an environment');
    print('Usage: dart scripts/switch_environment.dart <environment>');
    print('Available environments: development, production');
    exit(1);
  }

  final environment = arguments[0].toLowerCase();
  final validEnvironments = ['development', 'production'];

  if (!validEnvironments.contains(environment)) {
    print('❌ Error: Invalid environment "$environment"');
    print('Available environments: ${validEnvironments.join(', ')}');
    exit(1);
  }

  try {
    switchEnvironment(environment);
    print('✅ Successfully switched to $environment environment');
    print('🔄 You may need to restart your Flutter app');
  } catch (e) {
    print('❌ Error switching environment: $e');
    exit(1);
  }
}

void switchEnvironment(String environment) {
  final sourceFile = File('.env.$environment');
  final targetFile = File('.env');

  // Check if source environment file exists
  if (!sourceFile.existsSync()) {
    throw Exception('Environment file .env.$environment not found');
  }

  // Create backup of current .env if it exists
  if (targetFile.existsSync()) {
    final backupFile = File('.env.backup');
    targetFile.copySync(backupFile.path);
    print('📄 Created backup: .env.backup');
  }

  // Copy environment file to .env
  sourceFile.copySync(targetFile.path);

  // Display configuration summary
  displayEnvironmentSummary(environment);
}

void displayEnvironmentSummary(String environment) {
  final envFile = File('.env');
  final lines = envFile.readAsLinesSync();

  String? apiBaseUrl;
  String? enableMockData;
  String? debugMode;

  for (final line in lines) {
    if (line.startsWith('API_BASE_URL=')) {
      apiBaseUrl = line.split('=')[1];
    } else if (line.startsWith('ENABLE_MOCK_DATA=')) {
      enableMockData = line.split('=')[1];
    } else if (line.startsWith('DEBUG_MODE=')) {
      debugMode = line.split('=')[1];
    }
  }

  print('\n📋 Environment Configuration Summary:');
  print('🌍 Environment: $environment');
  print('🔗 API URL: $apiBaseUrl');
  print('🎭 Mock Data: $enableMockData');
  print('🐛 Debug Mode: $debugMode');

  if (environment == 'production') {
    print('\n⚠️  Production Environment Notes:');
    print('   • Backend deployed on Render');
    print('   • Cold starts may take 30-60 seconds');
    print('   • Mock data is disabled');
    print('   • Debug logging is disabled');
  } else {
    print('\n🛠️  Development Environment Notes:');
    print('   • Local backend expected at localhost:8002');
    print('   • Mock data enabled as fallback');
    print('   • Debug logging enabled');
  }
}
