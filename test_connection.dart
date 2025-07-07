// Simple test file to check backend connection
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  print('🧪 Testing EmoSense Backend Connection...');
  print('📡 Backend URL: http://localhost:8000');

  try {
    // Test health endpoint
    print('\n1. Testing health endpoint...');
    final healthResponse = await http
        .get(
          Uri.parse('http://localhost:8000/health'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(Duration(seconds: 5));

    if (healthResponse.statusCode == 200) {
      print('✅ Health check: SUCCESS');
      print('📊 Response: ${healthResponse.body}');
    } else {
      print('❌ Health check: FAILED (${healthResponse.statusCode})');
      return;
    }

    // Test emotion analysis
    print('\n2. Testing emotion analysis...');
    final analysisResponse = await http
        .post(
          Uri.parse('http://localhost:8000/analyze/text'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'text': 'I am very happy today!'}),
        )
        .timeout(Duration(seconds: 10));

    if (analysisResponse.statusCode == 200) {
      print('✅ Emotion analysis: SUCCESS');
      final result = json.decode(analysisResponse.body);
      print('🎭 Emotion: ${result['emotion']}');
      print(
        '📈 Confidence: ${(result['confidence'] * 100).toStringAsFixed(1)}%',
      );
      print('🤖 Model: ${result['model_used']}');
      print(
        '⏱️  Time: ${(result['processing_time'] * 1000).toStringAsFixed(1)}ms',
      );
    } else {
      print('❌ Emotion analysis: FAILED (${analysisResponse.statusCode})');
      print('📄 Response: ${analysisResponse.body}');
    }
  } catch (e) {
    print('❌ Connection error: $e');
    print('\n💡 Make sure the backend server is running:');
    print('   cd e:\\emosense_backend');
    print('   .venv\\Scripts\\Activate.ps1');
    print('   python simple_localhost_server.py');
  }

  print('\n🏁 Test completed!');
}
