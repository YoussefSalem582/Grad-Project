import 'package:flutter/material.dart';
import '../models/text_analysis_models.dart';
import '../../core/core.dart';

/// Data provider for text analysis screen
///
/// This class manages all static data, sample data, and configuration
/// for the text analysis functionality, keeping the UI widgets clean.
class TextAnalysisDataProvider {
  /// Available analysis types
  static const List<String> analysisTypes = [
    'Sentiment Analysis',
    'Emotion Detection',
    'Topic Classification',
    'Intent Recognition',
    'Language Detection',
  ];

  /// Quick statistics for the header
  static const List<AnalysisHeaderStat> quickStats = [
    AnalysisHeaderStat(value: '47', label: 'Analyzed', icon: Icons.analytics),
    AnalysisHeaderStat(value: '94%', label: 'Accuracy', icon: Icons.verified),
    AnalysisHeaderStat(value: '1.2s', label: 'Speed', icon: Icons.speed),
  ];

  /// Sample analysis history items
  static List<AnalysisHistoryItem> getSampleHistory() {
    return [
      AnalysisHistoryItem(
        id: '1',
        title: 'Customer Service Analysis',
        type: 'Sentiment Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        confidence: 0.94,
        result: {
          'sentiment': 'Positive',
          'confidence': 0.94,
          'emotions': {'joy': 0.8, 'satisfaction': 0.9},
        },
      ),
      AnalysisHistoryItem(
        id: '2',
        title: 'Email Emotion Detection',
        type: 'Emotion Detection',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        confidence: 0.88,
        result: {
          'primaryEmotion': 'Joy',
          'confidence': 0.88,
          'emotions': {'joy': 0.88, 'excitement': 0.6, 'gratitude': 0.7},
        },
      ),
      AnalysisHistoryItem(
        id: '3',
        title: 'Support Ticket Classification',
        type: 'Topic Classification',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        confidence: 0.82,
        result: {
          'primaryTopic': 'Technical Support',
          'confidence': 0.82,
          'categories': ['technical', 'urgent', 'account-related'],
        },
      ),
      AnalysisHistoryItem(
        id: '4',
        title: 'Intent Analysis',
        type: 'Intent Recognition',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        confidence: 0.91,
        result: {
          'primaryIntent': 'Purchase Inquiry',
          'confidence': 0.91,
          'intents': ['purchase', 'information-seeking', 'comparison'],
        },
      ),
      AnalysisHistoryItem(
        id: '5',
        title: 'Multilingual Content',
        type: 'Language Detection',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        confidence: 0.98,
        result: {
          'primaryLanguage': 'English',
          'confidence': 0.98,
          'detectedLanguages': ['en', 'es', 'fr'],
        },
      ),
    ];
  }

  /// Get quick actions for the analysis screen
  static List<AnalysisQuickAction> getQuickActions({
    required VoidCallback onBatchProcessing,
    required VoidCallback onExportResults,
    required VoidCallback onCompareTexts,
    required VoidCallback onSettings,
  }) {
    return [
      AnalysisQuickAction(
        title: 'Batch Analysis',
        description: 'Analyze multiple texts',
        icon: Icons.batch_prediction,
        color: AppColors.primary,
        onTap: onBatchProcessing,
      ),
      AnalysisQuickAction(
        title: 'Export Results',
        description: 'Save analysis to file',
        icon: Icons.file_download,
        color: AppColors.secondary,
        onTap: onExportResults,
      ),
      AnalysisQuickAction(
        title: 'Compare Texts',
        description: 'Side-by-side analysis',
        icon: Icons.compare_arrows,
        color: AppColors.success,
        onTap: onCompareTexts,
      ),
      AnalysisQuickAction(
        title: 'Settings',
        description: 'Configure analysis',
        icon: Icons.settings,
        color: AppColors.warning,
        onTap: onSettings,
      ),
    ];
  }

  /// Get analysis type configuration
  static Map<String, dynamic> getAnalysisTypeConfig(String analysisType) {
    switch (analysisType) {
      case 'Sentiment Analysis':
        return {
          'icon': Icons.sentiment_satisfied,
          'color': Colors.green,
          'description': 'Analyze positive, negative, and neutral sentiment',
          'features': [
            'Polarity Detection',
            'Intensity Scoring',
            'Confidence Rating',
          ],
        };
      case 'Emotion Detection':
        return {
          'icon': Icons.psychology,
          'color': Colors.orange,
          'description':
              'Detect specific emotions like joy, anger, fear, sadness',
          'features': [
            'Multi-emotion Detection',
            'Intensity Levels',
            'Emotion Confidence',
          ],
        };
      case 'Topic Classification':
        return {
          'icon': Icons.category,
          'color': Colors.blue,
          'description': 'Categorize content by subject or theme',
          'features': [
            'Multi-topic Support',
            'Hierarchical Classification',
            'Custom Categories',
          ],
        };
      case 'Intent Recognition':
        return {
          'icon': Icons.lightbulb,
          'color': Colors.purple,
          'description': 'Understand user intentions and goals',
          'features': [
            'Intent Prediction',
            'Confidence Scoring',
            'Action Suggestions',
          ],
        };
      case 'Language Detection':
        return {
          'icon': Icons.language,
          'color': Colors.teal,
          'description': 'Automatically identify text language',
          'features': [
            '100+ Languages',
            'Script Detection',
            'Mixed Language Support',
          ],
        };
      default:
        return {
          'icon': Icons.analytics,
          'color': AppColors.primary,
          'description': 'Advanced text analysis',
          'features': ['AI-Powered', 'Real-time', 'High Accuracy'],
        };
    }
  }
}
