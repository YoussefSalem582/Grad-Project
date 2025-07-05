import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Widget specifically for displaying text analysis results
class TextAnalysisResultWidget extends StatelessWidget {
  final Map<String, dynamic>? result;
  final bool isLoading;
  final String analysisType;
  final VoidCallback? onRetry;
  final VoidCallback? onShare;
  final VoidCallback? onSave;

  const TextAnalysisResultWidget({
    super.key,
    this.result,
    required this.isLoading,
    required this.analysisType,
    this.onRetry,
    this.onShare,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    if (isLoading) {
      return _buildLoadingState(theme, customSpacing);
    }

    if (result == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, customSpacing),
          SizedBox(height: customSpacing.lg),
          _buildResultContent(theme, customSpacing),
          SizedBox(height: customSpacing.lg),
          _buildActionButtons(theme, customSpacing),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme, CustomSpacing spacing) {
    return Container(
      margin: EdgeInsets.all(spacing.md),
      padding: EdgeInsets.all(spacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: spacing.lg),
          Text(
            'Analyzing your text...',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            'This may take a few seconds',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing spacing) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(spacing.sm),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.check_circle, color: AppColors.success, size: 24),
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Analysis Complete',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                analysisType,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _getConfidenceText(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultContent(ThemeData theme, CustomSpacing spacing) {
    switch (analysisType) {
      case 'Sentiment Analysis':
        return _buildSentimentResults(theme, spacing);
      case 'Emotion Detection':
        return _buildEmotionResults(theme, spacing);
      case 'Topic Classification':
        return _buildTopicResults(theme, spacing);
      case 'Intent Recognition':
        return _buildIntentResults(theme, spacing);
      case 'Language Detection':
        return _buildLanguageResults(theme, spacing);
      default:
        return _buildGenericResults(theme, spacing);
    }
  }

  Widget _buildSentimentResults(ThemeData theme, CustomSpacing spacing) {
    final sentiment = result!['sentiment'] as String;
    final score = (result!['score'] as double?) ?? 0.0;
    final emotions = result!['emotions'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainResult(
          'Sentiment',
          sentiment,
          score,
          _getSentimentColor(sentiment),
          theme,
          spacing,
        ),
        if (emotions.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            'Emotion Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          ...emotions.entries.map(
            (entry) => _buildEmotionBar(
              entry.key,
              entry.value as double,
              theme,
              spacing,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmotionResults(ThemeData theme, CustomSpacing spacing) {
    final primaryEmotion = result!['primaryEmotion'] as String;
    final emotions = result!['emotions'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainResult(
          'Primary Emotion',
          primaryEmotion,
          (emotions[primaryEmotion.toLowerCase()] as double?) ?? 0.0,
          _getEmotionColor(primaryEmotion),
          theme,
          spacing,
        ),
        if (emotions.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            'All Emotions',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          ...emotions.entries.map(
            (entry) => _buildEmotionBar(
              entry.key,
              entry.value as double,
              theme,
              spacing,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTopicResults(ThemeData theme, CustomSpacing spacing) {
    final primaryTopic = result!['primaryTopic'] as String;
    final topics = result!['topics'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainResult(
          'Primary Topic',
          primaryTopic,
          topics.isNotEmpty ? topics.first['confidence'] as double : 0.0,
          AppColors.info,
          theme,
          spacing,
        ),
        if (topics.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            'All Topics',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          ...topics.map(
            (topic) => _buildEmotionBar(
              topic['name'] as String,
              topic['confidence'] as double,
              theme,
              spacing,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIntentResults(ThemeData theme, CustomSpacing spacing) {
    final intent = result!['intent'] as String;
    final confidence = (result!['confidence'] as double?) ?? 0.0;
    final subIntents = result!['subIntents'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainResult(
          'Detected Intent',
          intent,
          confidence,
          AppColors.warning,
          theme,
          spacing,
        ),
        if (subIntents.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            'Sub-intents',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          ...subIntents.map(
            (intent) => _buildEmotionBar(
              intent['name'] as String,
              intent['confidence'] as double,
              theme,
              spacing,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLanguageResults(ThemeData theme, CustomSpacing spacing) {
    final language = result!['language'] as String;
    final confidence = (result!['confidence'] as double?) ?? 0.0;
    final alternatives = result!['alternatives'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMainResult(
          'Detected Language',
          language,
          confidence,
          AppColors.secondary,
          theme,
          spacing,
        ),
        if (alternatives.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            'Alternative Languages',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          ...alternatives.map(
            (lang) => _buildEmotionBar(
              lang['language'] as String,
              lang['confidence'] as double,
              theme,
              spacing,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGenericResults(ThemeData theme, CustomSpacing spacing) {
    return Text(
      result.toString(),
      style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
    );
  }

  Widget _buildMainResult(
    String label,
    String value,
    double confidence,
    Color color,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${(confidence * 100).toInt()}%',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'confidence',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBar(
    String name,
    double value,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name.toUpperCase(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(_getEmotionColor(name)),
            ),
          ),
          SizedBox(width: spacing.md),
          Text(
            '${(value * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, CustomSpacing spacing) {
    return Row(
      children: [
        if (onRetry != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Re-analyze'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (onRetry != null && (onShare != null || onSave != null))
          SizedBox(width: spacing.md),
        if (onShare != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onShare,
              icon: const Icon(Icons.share),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        if (onSave != null && onShare != null) SizedBox(width: spacing.md),
        if (onSave != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getConfidenceText() {
    if (result == null) return '0%';

    final confidence =
        result!['confidence'] as double? ?? result!['score'] as double? ?? 0.0;
    return '${(confidence * 100).toInt()}%';
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return AppColors.success;
      case 'negative':
        return AppColors.error;
      case 'neutral':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'joy':
      case 'happiness':
        return AppColors.success;
      case 'sadness':
      case 'fear':
        return AppColors.error;
      case 'anger':
        return Colors.red;
      case 'surprise':
        return Colors.orange;
      case 'trust':
        return AppColors.info;
      case 'anticipation':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }
}
