import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';


import '../../../core/core.dart';

class ResultsCard extends StatelessWidget {
  const ResultsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EmotionProvider>(
      builder: (context, provider, child) {
        final result = provider.emotionResult;
        if (result == null) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildMainResult(result),
                const SizedBox(height: 20),
                _buildEmotionBreakdown(result),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(Icons.analytics, color: AppColors.primary, size: 28),
        SizedBox(width: 12),
        Text(
          AppStrings.emotionAnalysis,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildMainResult(result) {
    final emotionColor = EmotionUtils.getEmotionColor(result.emotion);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            emotionColor.withValues(alpha: 0.1),
            emotionColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: emotionColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: emotionColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                EmotionUtils.getEmotionEmoji(result.emotion),
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.emotion.toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: emotionColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.sentiment}: ${result.sentiment}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${EmotionUtils.formatConfidence(result.confidence)} ${AppStrings.confident}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (result.processingTimeMs != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.speed,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        EmotionUtils.formatProcessingTime(
                          result.processingTimeMs!,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBreakdown(result) {
    final sortedEmotions = EmotionUtils.getSortedEmotions(result.allEmotions);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.detailedBreakdown,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...sortedEmotions.map((entry) => _buildEmotionItem(entry)),
      ],
    );
  }

  Widget _buildEmotionItem(MapEntry<String, double> entry) {
    final emotionColor = EmotionUtils.getEmotionColor(entry.key);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: emotionColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: emotionColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                EmotionUtils.getEmotionEmoji(entry.key),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              entry.key,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: entry.value,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [emotionColor, emotionColor.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            EmotionUtils.formatConfidence(entry.value),
            style: TextStyle(fontWeight: FontWeight.w600, color: emotionColor),
          ),
        ],
      ),
    );
  }
}

