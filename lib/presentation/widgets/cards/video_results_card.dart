import 'package:flutter/material.dart';
import '../../../data/data.dart';
import '../../../core/core.dart';

class VideoResultsCard extends StatelessWidget {
  final VideoAnalysisResponse result;

  const VideoResultsCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video Analysis Results',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSummarySection(context),
            const Divider(),
            _buildFramesList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Summary', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        _buildInfoRow('Frames Analyzed:', result.framesAnalyzed.toString()),
        _buildInfoRow('Dominant Emotion:', result.dominantEmotion),
        _buildInfoRow(
          'Average Confidence:',
          '${(result.averageConfidence * 100).toStringAsFixed(1)}%',
        ),
      ],
    );
  }

  Widget _buildFramesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frame Details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: result.frameResults.length,
            itemBuilder: (context, index) {
              final frame = result.frameResults[index];
              return ListTile(
                title: Text('Frame ${frame.frameNumber}'),
                subtitle: Text(
                  'Emotion: ${frame.emotionResult.emotion}\n'
                  'Confidence: ${(frame.emotionResult.confidence * 100).toStringAsFixed(1)}%\n'
                  'Timestamp: ${frame.timestamp.toStringAsFixed(2)}s',
                ),
                leading: CircleAvatar(
                  backgroundColor: EmotionUtils.getEmotionColor(
                    frame.emotionResult.emotion,
                  ),
                  child: Text(
                    frame.emotionResult.emotion[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}
