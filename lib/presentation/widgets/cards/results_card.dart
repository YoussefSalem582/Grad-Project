import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';
import '../widgets.dart';
import '../../../core/core.dart';

class ResultsCard extends StatelessWidget {
  const ResultsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EmotionProvider>(
      builder: (context, provider, child) {
        final result = provider.emotionResult;
        if (result == null) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Enhanced Main Results Display
            GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEnhancedHeader(),
                  const SizedBox(height: 24),
                  _buildPrimaryEmotionDisplay(result),
                  const SizedBox(height: 24),
                  _buildQuickStats(result),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Detailed Analysis Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emotion Breakdown
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.pie_chart,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Emotion Breakdown',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._buildAdvancedEmotionBreakdown(result),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // AI Insights
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Insights',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ..._buildAIInsights(result),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Recommendations
            GlassCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.recommend,
                          color: AppColors.info,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Recommended Actions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _buildActionRecommendations(result)
                        .map(
                          (action) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: (action['color'] as Color).withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: (action['color'] as Color).withValues(
                                  alpha: 0.3,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  action['icon'] as IconData,
                                  color: action['color'] as Color,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  action['text'] as String,
                                  style: TextStyle(
                                    color: action['color'] as Color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEnhancedHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: AppColors.successGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.analytics, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Complete',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Comprehensive emotion analysis results',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'COMPLETE',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryEmotionDisplay(result) {
    final emotionColor = EmotionUtils.getEmotionColor(result.emotion);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _getEmotionGradient(result.emotion),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: emotionColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                EmotionUtils.getEmotionEmoji(result.emotion),
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            result.emotion.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sentiment: ${result.sentiment}',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              'Confidence: ${EmotionUtils.formatConfidence(result.confidence)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(result) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Processing Time',
            EmotionUtils.formatProcessingTime(result.processingTimeMs ?? 0),
            Icons.speed,
            AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Accuracy',
            '${(result.confidence * 100).toInt()}%',
            Icons.verified,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Emotions',
            '${result.allEmotions.length}',
            Icons.psychology,
            AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAdvancedEmotionBreakdown(result) {
    final sortedEmotions = EmotionUtils.getSortedEmotions(result.allEmotions);

    return sortedEmotions.take(5).map((entry) {
      final percentage = (entry.value * 100).toInt();
      final emotionColor = EmotionUtils.getEmotionColor(entry.key);

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: emotionColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: entry.value,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(emotionColor),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildAIInsights(result) {
    final insights = [
      {
        'text': 'Primary: ${result.emotion}',
        'icon': Icons.psychology,
        'color': EmotionUtils.getEmotionColor(result.emotion),
      },
      {
        'text': 'Sentiment: ${result.sentiment}',
        'icon': Icons.trending_up,
        'color': _getSentimentColor(result.sentiment),
      },
      {
        'text': 'High Confidence',
        'icon': Icons.verified,
        'color': AppColors.success,
      },
      {
        'text': 'Analysis Ready',
        'icon': Icons.check_circle,
        'color': AppColors.primary,
      },
    ];

    return insights.map((insight) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (insight['color'] as Color).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (insight['color'] as Color).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              insight['icon'] as IconData,
              color: insight['color'] as Color,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                insight['text'] as String,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: insight['color'] as Color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Map<String, dynamic>> _buildActionRecommendations(result) {
    final sentiment = result.sentiment.toLowerCase();
    final emotion = result.emotion.toLowerCase();

    if (sentiment.contains('positive') ||
        emotion.contains('happy') ||
        emotion.contains('joy')) {
      return [
        {
          'text': 'Thank Customer',
          'icon': Icons.favorite,
          'color': AppColors.success,
        },
        {'text': 'Share Success', 'icon': Icons.share, 'color': AppColors.info},
        {
          'text': 'Follow Up',
          'icon': Icons.schedule,
          'color': AppColors.primary,
        },
      ];
    } else if (sentiment.contains('negative') ||
        emotion.contains('angry') ||
        emotion.contains('sad')) {
      return [
        {
          'text': 'Priority Response',
          'icon': Icons.priority_high,
          'color': AppColors.error,
        },
        {
          'text': 'Escalate',
          'icon': Icons.arrow_upward,
          'color': AppColors.warning,
        },
        {
          'text': 'Offer Solution',
          'icon': Icons.lightbulb,
          'color': AppColors.primary,
        },
      ];
    } else {
      return [
        {
          'text': 'Standard Reply',
          'icon': Icons.reply,
          'color': AppColors.primary,
        },
        {'text': 'Get More Info', 'icon': Icons.info, 'color': AppColors.info},
        {'text': 'Monitor', 'icon': Icons.monitor, 'color': AppColors.warning},
      ];
    }
  }

  LinearGradient _getEmotionGradient(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
        );
      case 'positive':
        return const LinearGradient(
          colors: [Color(0xFF2196F3), Color(0xFF03DAC6)],
        );
      case 'neutral':
        return const LinearGradient(
          colors: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
        );
      case 'negative':
        return const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
        );
      case 'angry':
        return const LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFFF5722)],
        );
      default:
        return AppColors.primaryGradient;
    }
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return AppColors.success;
      case 'negative':
        return AppColors.error;
      case 'neutral':
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }
}
