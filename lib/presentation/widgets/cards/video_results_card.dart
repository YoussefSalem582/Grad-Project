import 'package:flutter/material.dart';
import '../../../data/data.dart';

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
            _buildSummarySnapshot(context),
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

  Widget _buildSummarySnapshot(BuildContext context) {
    final snapshot = result.summarySnapshot;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),

        // Emotion and Sentiment Row
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getEmotionColor(
                    snapshot.emotion,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getEmotionColor(
                      snapshot.emotion,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_rounded,
                      color: _getEmotionColor(snapshot.emotion),
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snapshot.emotion,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getEmotionColor(snapshot.emotion),
                      ),
                    ),
                    Text(
                      'Emotion',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getSentimentColor(
                    snapshot.sentiment,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getSentimentColor(
                      snapshot.sentiment,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: _getSentimentColor(snapshot.sentiment),
                      size: 32,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snapshot.sentiment.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getSentimentColor(snapshot.sentiment),
                      ),
                    ),
                    Text(
                      'Sentiment',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Frame Image Display
        if (snapshot.assetImagePath != null) ...[
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                snapshot.assetImagePath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Image not available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Summary Text
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description_rounded,
                    size: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Analysis Summary',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                snapshot.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Emotion Distribution
        if (snapshot.emotionDistribution.isNotEmpty) ...[
          Text(
            'Emotion Distribution',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          ...snapshot.emotionDistribution.entries.map((entry) {
            final emotion = entry.key;
            final count = entry.value;
            final percentage =
                (count / snapshot.totalFramesAnalyzed * 100).round();

            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      emotion,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _getEmotionColor(emotion),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: count / snapshot.totalFramesAnalyzed,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getEmotionColor(emotion),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$percentage%',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
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

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return const Color(0xFF10B981);
      case 'excited':
      case 'enthusiastic':
        return const Color(0xFFF59E0B);
      case 'confident':
        return const Color(0xFF3B82F6);
      case 'serious':
      case 'neutral':
        return const Color(0xFF6B7280);
      case 'sad':
        return const Color(0xFF8B5CF6);
      case 'angry':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF8B5CF6);
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return const Color(0xFF10B981);
      case 'negative':
        return const Color(0xFFEF4444);
      case 'neutral':
      default:
        return const Color(0xFF6B7280);
    }
  }
}
