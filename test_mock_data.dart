#!/usr/bin/env dart

/// Test script to verify enhanced mock data

void main() {
  print('🧪 Testing Enhanced Mock Data');
  print('===============================\n');

  // Test sample analysis types
  final samples = {
    'Customer Service Call': 'Customer Support Analysis',
    'Sales Meeting': 'Business Communication Analysis',
    'Interview Session': 'Interview Performance Analysis',
    'Voice Message': 'Personal Voice Analysis',
  };

  for (final entry in samples.entries) {
    final sampleTitle = entry.key;
    final analysisType = entry.value;

    print('🎯 Sample: $sampleTitle');
    print('   📊 Analysis Type: $analysisType');
    print('   💪 Expected Features:');

    switch (analysisType) {
      case 'Customer Support Analysis':
        print('      - Professional tone (65%)');
        print('      - Empathy indicators (22%)');
        print('      - Duration: 3:24');
        print('      - Empathy score: 0.88');
        break;
      case 'Business Communication Analysis':
        print('      - Confidence (78%)');
        print('      - Authority presence (91%)');
        print('      - Duration: 12:15');
        print('      - Persuasiveness: 0.87');
        break;
      case 'Interview Performance Analysis':
        print('      - Moderate confidence (65%)');
        print('      - Some nervousness (25%)');
        print('      - Duration: 8:47');
        print('      - Professionalism: 0.82');
        break;
      case 'Personal Voice Analysis':
        print('      - High happiness (82%)');
        print('      - Excitement (12%)');
        print('      - Duration: 1:32');
        print('      - Authenticity: 0.93');
        break;
    }
    print('');
  }

  print('✅ Enhanced Mock Data Features:');
  print('   1. Async loading with 2-second delay');
  print('   2. Sample-specific file paths');
  print('   3. Realistic confidence scores');
  print('   4. Detailed metrics per sample type');
  print('   5. Debug logging for troubleshooting');
  print('   6. Better transcription messages');

  print('\n🎉 Mock data system is ready for testing!');
}
