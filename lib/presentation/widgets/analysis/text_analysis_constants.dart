import 'package:flutter/material.dart';
import '../../../core/core.dart';
import 'analysis_quick_actions_widget.dart';
import 'analysis_history_widget.dart';

/// Constants for the Enhanced Text Analysis screen
///
/// Contains all constant data like analysis types, templates,
/// sample history items, and quick actions configuration.
class TextAnalysisConstants {
  /// Available analysis types
  static const List<String> analysisTypes = [
    'Sentiment Analysis',
    'Emotion Detection',
    'Topic Classification',
    'Intent Recognition',
    'Language Detection',
  ];

  /// Quick actions configuration
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

  /// Sample analysis history
  static List<AnalysisHistoryItem> get sampleHistory {
    return [
      AnalysisHistoryItem(
        id: '1',
        title: 'Customer Service Analysis',
        type: 'Sentiment Analysis',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        confidence: 0.94,
        result: {'sentiment': 'Positive', 'confidence': 0.94},
      ),
      AnalysisHistoryItem(
        id: '2',
        title: 'Email Emotion Detection',
        type: 'Emotion Detection',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        confidence: 0.88,
        result: {'primaryEmotion': 'Joy', 'confidence': 0.88},
      ),
      AnalysisHistoryItem(
        id: '3',
        title: 'Support Ticket Classification',
        type: 'Topic Classification',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        confidence: 0.82,
        result: {'primaryTopic': 'Technical Support', 'confidence': 0.82},
      ),
    ];
  }

  /// Default selected analysis type
  static const String defaultAnalysisType = 'Sentiment Analysis';

  /// Animation duration constants
  static const Duration backgroundAnimationDuration = Duration(seconds: 8);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 1200);
}
