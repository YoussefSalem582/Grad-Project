import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

import '../../widgets/widgets.dart';

class VideoAnalyzerScreen extends StatelessWidget {
  const VideoAnalyzerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Emotion Analysis')),
      body: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VideoAnalysisForm(),
                if (provider.isVideoLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Analyzing video...\nThis may take a few minutes.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                if (provider.error != null)
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Error',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider.error!,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => provider.clearError(),
                            child: const Text('Dismiss'),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (provider.lastVideoResult != null)
                  VideoResultsCard(result: provider.lastVideoResult!),
              ],
            ),
          );
        },
      ),
    );
  }
}
