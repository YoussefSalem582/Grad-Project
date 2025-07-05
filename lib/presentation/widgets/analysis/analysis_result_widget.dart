import 'package:flutter/material.dart';
import '../../../core/core.dart';

class AnalysisResultWidget extends StatefulWidget {
  final Map<String, dynamic>? result;
  final bool isLoading;
  final String analysisType;
  final VoidCallback? onRetry;
  final Widget? customResultContent;

  const AnalysisResultWidget({
    super.key,
    this.result,
    required this.isLoading,
    required this.analysisType,
    this.onRetry,
    this.customResultContent,
  });

  @override
  State<AnalysisResultWidget> createState() => _AnalysisResultWidgetState();
}

class _AnalysisResultWidgetState extends State<AnalysisResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    if (widget.result != null || widget.isLoading) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(AnalysisResultWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.result != null || widget.isLoading) &&
        (oldWidget.result == null && !oldWidget.isLoading)) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    if (!widget.isLoading && widget.result == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.all(customSpacing.md),
          padding: EdgeInsets.all(customSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  SizedBox(width: customSpacing.sm),
                  Text(
                    '${widget.analysisType} Results',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  if (widget.onRetry != null)
                    IconButton(
                      onPressed: widget.onRetry,
                      icon: Icon(Icons.refresh, color: AppColors.primary),
                    ),
                ],
              ),
              SizedBox(height: customSpacing.md),
              if (widget.isLoading)
                _buildLoadingState(customSpacing)
              else if (widget.customResultContent != null)
                widget.customResultContent!
              else
                _buildDefaultResultContent(theme, customSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(CustomSpacing spacing) {
    return Column(
      children: [
        SizedBox(height: spacing.lg),
        Center(
          child: Column(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              SizedBox(height: spacing.md),
              Text(
                'Analyzing...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing.lg),
      ],
    );
  }

  Widget _buildDefaultResultContent(ThemeData theme, CustomSpacing spacing) {
    if (widget.result == null) return const SizedBox.shrink();

    final result = widget.result!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (result['confidence'] != null)
          _buildConfidenceBar(result['confidence'], spacing),

        if (result['sentiment'] != null)
          _buildSentimentResult(result['sentiment'], theme, spacing),

        if (result['emotions'] != null)
          _buildEmotionsResult(result['emotions'], theme, spacing),

        if (result['keywords'] != null)
          _buildKeywordsResult(result['keywords'], theme, spacing),

        if (result['summary'] != null)
          _buildSummaryResult(result['summary'], theme, spacing),
      ],
    );
  }

  Widget _buildConfidenceBar(double confidence, CustomSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Confidence',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(confidence * 100).toInt()}%',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.xs),
        LinearProgressIndicator(
          value: confidence,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        SizedBox(height: spacing.md),
      ],
    );
  }

  Widget _buildSentimentResult(
    String sentiment,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    Color sentimentColor = _getSentimentColor(sentiment);
    IconData sentimentIcon = _getSentimentIcon(sentiment);

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: sentimentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: sentimentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(sentimentIcon, color: sentimentColor, size: 24),
          SizedBox(width: spacing.sm),
          Text(
            'Sentiment: ${sentiment.toUpperCase()}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: sentimentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionsResult(
    List<dynamic> emotions,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detected Emotions',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.sm),
        Wrap(
          spacing: spacing.xs,
          runSpacing: spacing.xs,
          children: emotions.map<Widget>((emotion) {
            return Chip(
              label: Text(emotion.toString()),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: AppColors.primary),
            );
          }).toList(),
        ),
        SizedBox(height: spacing.md),
      ],
    );
  }

  Widget _buildKeywordsResult(
    List<dynamic> keywords,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Topics',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.sm),
        Wrap(
          spacing: spacing.xs,
          runSpacing: spacing.xs,
          children: keywords.map<Widget>((keyword) {
            return Chip(
              label: Text(keyword.toString()),
              backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
              labelStyle: TextStyle(color: AppColors.secondary),
            );
          }).toList(),
        ),
        SizedBox(height: spacing.md),
      ],
    );
  }

  Widget _buildSummaryResult(
    String summary,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Summary',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.sm),
        Container(
          padding: EdgeInsets.all(spacing.md),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            summary,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return AppColors.success;
      case 'negative':
        return AppColors.error;
      case 'neutral':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getSentimentIcon(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return Icons.sentiment_very_satisfied;
      case 'negative':
        return Icons.sentiment_very_dissatisfied;
      case 'neutral':
        return Icons.sentiment_neutral;
      default:
        return Icons.help_outline;
    }
  }
}
