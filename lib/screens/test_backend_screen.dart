// lib/screens/test_backend_screen.dart
import 'package:flutter/material.dart';
import '../core/config/api_config.dart';

class TestBackendScreen extends StatefulWidget {
  const TestBackendScreen({Key? key}) : super(key: key);

  @override
  State<TestBackendScreen> createState() => _TestBackendScreenState();
}

class _TestBackendScreenState extends State<TestBackendScreen> {
  final TextEditingController _textController = TextEditingController();
  final EmotionApiService _apiService = EmotionApiService();

  String _status = 'Not connected';
  String _lastResult = '';
  bool _isLoading = false;
  bool _isHealthy = false;

  @override
  void initState() {
    super.initState();
    _checkBackendHealth();
  }

  Future<void> _checkBackendHealth() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking connection...';
    });

    try {
      final isHealthy = await _apiService.checkHealth();
      setState(() {
        _isHealthy = isHealthy;
        _status = isHealthy ? 'Connected ✅' : 'Connection failed ❌';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _isHealthy = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _testTextAnalysis() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter some text')));
      return;
    }

    setState(() {
      _isLoading = true;
      _lastResult = 'Analyzing...';
    });

    try {
      final result = await _apiService.analyzeText(_textController.text.trim());
      setState(() {
        _lastResult = '''
Emotion: ${result['emotion']}
Confidence: ${(result['confidence'] * 100).toStringAsFixed(1)}%
Model: ${result['model_used']}
Time: ${(result['processing_time'] * 1000).toStringAsFixed(1)}ms
''';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lastResult = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backend Connection Test'),
        backgroundColor: _isHealthy ? Colors.green : Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Backend Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: TextStyle(
                        fontSize: 18,
                        color: _isHealthy ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'API URL: ${ApiConfig.baseUrl}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _checkBackendHealth,
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Test Connection'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Text Analysis Test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Text Emotion Analysis',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText:
                            'Enter text to analyze (e.g., "I am very happy today!")',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          _isLoading || !_isHealthy ? null : _testTextAnalysis,
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Analyze Emotion'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Results
            if (_lastResult.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Result',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _lastResult,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
