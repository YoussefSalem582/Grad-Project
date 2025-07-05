import 'package:flutter/material.dart';
import '../../../core/core.dart';

class VideoAnalysisResultWidget extends StatefulWidget {
  final Map<String, dynamic> result;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;

  const VideoAnalysisResultWidget({
    super.key,
    required this.result,
    this.isExpanded = false,
    this.onToggleExpand,
  });

  @override
  State<VideoAnalysisResultWidget> createState() =>
      _VideoAnalysisResultWidgetState();
}

class _VideoAnalysisResultWidgetState extends State<VideoAnalysisResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
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

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          margin: EdgeInsets.all(customSpacing.md),
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
              // Header
              _buildHeader(theme, customSpacing),

              // Overall Score
              _buildOverallScore(theme, customSpacing),

              // Analysis Categories
              _buildAnalysisCategories(theme, customSpacing),

              // Insights & Recommendations
              if (widget.isExpanded) ...[
                _buildInsights(theme, customSpacing),
                _buildRecommendations(theme, customSpacing),
                _buildKeyMoments(theme, customSpacing),
              ],

              // Toggle Button
              _buildToggleButton(theme, customSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing spacing) {
    final duration = widget.result['duration'] as String? ?? 'Unknown';
    final analysisType =
        widget.result['analysis_type'] as String? ?? 'Full Analysis';

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.video_camera_back, color: Colors.white, size: 28),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video Analysis Complete',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      'Duration: $duration',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: spacing.md),
                    Icon(
                      Icons.analytics,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      analysisType,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
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
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 16),
                SizedBox(width: spacing.xs),
                Text(
                  'Complete',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScore(ThemeData theme, CustomSpacing spacing) {
    final overallScore =
        (widget.result['overall_score'] as double? ?? 0.0) * 100;

    return Container(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Analysis Score',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.success.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${overallScore.toInt()}%',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getScoreLabel(overallScore),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _getScoreColor(overallScore),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(flex: 2, child: _buildScoreBreakdown(theme, spacing)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown(ThemeData theme, CustomSpacing spacing) {
    final categories = [
      {'name': 'Facial Expression', 'score': 0.85, 'color': AppColors.primary},
      {'name': 'Body Language', 'score': 0.78, 'color': AppColors.secondary},
      {'name': 'Voice Quality', 'score': 0.89, 'color': AppColors.success},
      {'name': 'Engagement', 'score': 0.82, 'color': AppColors.warning},
    ];

    return Column(
      children: categories.map((category) {
        final score = (category['score'] as double) * 100;
        final color = category['color'] as Color;

        return Padding(
          padding: EdgeInsets.only(bottom: spacing.sm),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  category['name'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: score / 100,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              Text(
                '${score.toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnalysisCategories(ThemeData theme, CustomSpacing spacing) {
    final facialAnalysis =
        widget.result['facial_analysis'] as Map<String, dynamic>? ?? {};
    final bodyLanguage =
        widget.result['body_language'] as Map<String, dynamic>? ?? {};

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Analysis',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: _buildCategoryCard(
                  'Facial Expression',
                  facialAnalysis,
                  Icons.face,
                  AppColors.primary,
                  theme,
                  spacing,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: _buildCategoryCard(
                  'Body Language',
                  bodyLanguage,
                  Icons.accessibility,
                  AppColors.secondary,
                  theme,
                  spacing,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    Map<String, dynamic> data,
    IconData icon,
    Color color,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ...data.entries.take(3).map((entry) {
            final score = (entry.value as double? ?? 0.0) * 100;
            return Padding(
              padding: EdgeInsets.only(bottom: spacing.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${score.toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInsights(ThemeData theme, CustomSpacing spacing) {
    final insights = widget.result['insights'] as List<dynamic>? ?? [];

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.warning, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Key Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ...insights.map(
            (insight) => _buildInsightItem(insight, theme, spacing),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations(ThemeData theme, CustomSpacing spacing) {
    final recommendations =
        widget.result['recommendations'] as List<dynamic>? ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.recommend, color: AppColors.success, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Recommendations',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ...recommendations.map(
            (rec) => _buildRecommendationItem(rec, theme, spacing),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMoments(ThemeData theme, CustomSpacing spacing) {
    final keyMoments = widget.result['key_moments'] as List<dynamic>? ?? [];

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: AppColors.info, size: 20),
              SizedBox(width: spacing.sm),
              Text(
                'Key Moments',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          ...keyMoments.map(
            (moment) => _buildKeyMomentItem(moment, theme, spacing),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(
    String insight,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.insights, color: AppColors.warning, size: 16),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              insight,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(
    String recommendation,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 16),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(
              recommendation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMomentItem(
    Map<String, dynamic> moment,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    final timestamp = moment['timestamp'] as String? ?? '';
    final description = moment['description'] as String? ?? '';

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.sm,
              vertical: spacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.info,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              timestamp,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(ThemeData theme, CustomSpacing spacing) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: TextButton.icon(
        onPressed: widget.onToggleExpand,
        icon: Icon(
          widget.isExpanded ? Icons.expand_less : Icons.expand_more,
          color: AppColors.primary,
        ),
        label: Text(
          widget.isExpanded ? 'Show Less' : 'Show More Details',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getScoreLabel(double score) {
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Good';
    if (score >= 70) return 'Average';
    if (score >= 60) return 'Below Average';
    return 'Needs Improvement';
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return AppColors.success;
    if (score >= 80) return AppColors.primary;
    if (score >= 70) return AppColors.warning;
    if (score >= 60) return AppColors.error;
    return AppColors.error;
  }
}
