import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// About dialog widget for the text analysis screen
///
/// This widget provides information about the text analysis features,
/// capabilities, and version information in a clean, branded dialog.
class TextAnalysisAboutDialog extends StatelessWidget {
  const TextAnalysisAboutDialog({super.key});

  /// Show the about dialog
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const TextAnalysisAboutDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text('AI Text Analysis'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced natural language processing powered by machine learning algorithms.',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),

            _buildFeatureSection('Features:', [
              '• Sentiment Analysis - Detect positive, negative, neutral sentiment',
              '• Emotion Detection - Identify joy, anger, fear, sadness, and more',
              '• Topic Classification - Categorize content by subject',
              '• Intent Recognition - Understand user intentions',
              '• Language Detection - Identify text language automatically',
            ]),

            const SizedBox(height: 16),

            _buildFeatureSection('Capabilities:', [
              '• Real-time analysis with instant results',
              '• Batch processing for multiple texts',
              '• Export results in multiple formats',
              '• Historical analysis tracking',
              '• Customizable analysis parameters',
            ]),

            const SizedBox(height: 16),

            _buildInfoSection(context),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }

  /// Build a feature section with title and list
  Widget _buildFeatureSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build the info section with version and technical details
  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Technical Information',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Version', '1.0.0'),
          _buildInfoRow('Engine', 'Transformer Models'),
          _buildInfoRow('Accuracy', '94%+ Average'),
          _buildInfoRow('Languages', '100+ Supported'),
          _buildInfoRow('Speed', '< 2s Response Time'),
        ],
      ),
    );
  }

  /// Build an info row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
