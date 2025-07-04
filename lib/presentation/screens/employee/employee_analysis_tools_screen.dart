import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../analysis/batch_processing_screen.dart';

class EmployeeAnalysisToolsScreen extends StatefulWidget {
  const EmployeeAnalysisToolsScreen({super.key});

  @override
  State<EmployeeAnalysisToolsScreen> createState() =>
      _EmployeeAnalysisToolsScreenState();
}

class _EmployeeAnalysisToolsScreenState
    extends State<EmployeeAnalysisToolsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(customSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: customSpacing.xl),
                _buildHeader(theme, customSpacing),
                SizedBox(height: customSpacing.xl),
                _buildQuickActions(customSpacing),
                SizedBox(height: customSpacing.xl),
                _buildAnalysisToolsGrid(customSpacing),
                SizedBox(height: customSpacing.xl),
                _buildRecentAnalysis(theme, customSpacing),
                SizedBox(height: customSpacing.xl),
                _buildAnalyticsInsights(theme, customSpacing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Tools',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  'AI-powered customer insights and analytics',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: customSpacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: customSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                      SizedBox(width: customSpacing.xs),
                      Text(
                        '12 tools available',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Quick Text Analysis',
                'Analyze text instantly',
                Icons.flash_on,
                AppColors.accent,
                () => _quickTextAnalysis(),
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildQuickActionCard(
                'Batch Processing',
                'Process multiple files',
                Icons.batch_prediction,
                AppColors.secondary,
                () => _batchAnalysis(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisToolsGrid(CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: customSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout based on screen width
            final screenWidth = constraints.maxWidth;
            final isTablet = screenWidth > 600;

            if (isTablet) {
              // Tablet: 2 cards on top row, 1 centered on bottom
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnalysisToolCard(
                          'Text Analysis',
                          'Messages, emails & feedback',
                          Icons.text_fields,
                          AppColors.secondary,
                          () => _navigateToAnalysis(5),
                        ),
                      ),
                      SizedBox(width: customSpacing.md),
                      Expanded(
                        child: _buildAnalysisToolCard(
                          'Voice Analysis',
                          'Calls, recordings & audio',
                          Icons.mic,
                          AppColors.success,
                          () => _navigateToAnalysis(6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: customSpacing.md),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 2,
                        child: _buildAnalysisToolCard(
                          'Video Analysis',
                          'Customer videos & interviews',
                          Icons.video_library,
                          const Color(0xFF667EEA),
                          () => _navigateToAnalysis(7),
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                ],
              );
            } else {
              // Mobile: vertical stack with better proportions
              return Column(
                children: [
                  _buildAnalysisToolCard(
                    'Text Analysis',
                    'Messages, emails & feedback',
                    Icons.text_fields,
                    AppColors.secondary,
                    () => _navigateToAnalysis(5),
                  ),
                  SizedBox(height: customSpacing.md),
                  _buildAnalysisToolCard(
                    'Voice Analysis',
                    'Calls, recordings & audio',
                    Icons.mic,
                    AppColors.success,
                    () => _navigateToAnalysis(6),
                  ),
                  SizedBox(height: customSpacing.md),
                  _buildAnalysisToolCard(
                    'Video Analysis',
                    'Customer videos & interviews',
                    Icons.video_library,
                    const Color(0xFF667EEA),
                    () => _navigateToAnalysis(7),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildAnalysisToolCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Fixed height for consistent look
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.05),
                      color.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Arrow indicator
            Positioned(
              top: 16,
              right: 16,
              child: Icon(
                Icons.arrow_forward,
                color: color.withValues(alpha: 0.6),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAnalysis(ThemeData theme, CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Analysis',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            TextButton(onPressed: () {}, child: const Text('View All')),
          ],
        ),
        SizedBox(height: customSpacing.md),
        ...List.generate(2, (index) {
          final titles = [
            'Customer Feedback Analysis',
            'Voice Call Quality Report',
          ];
          final subtitles = [
            'Text analysis • 2 hours ago',
            'Voice analysis • 1 day ago',
          ];
          final colors = [AppColors.secondary, AppColors.success];
          final icons = [Icons.text_fields, Icons.mic];

          return Container(
            margin: EdgeInsets.only(bottom: customSpacing.sm),
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors[index].withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(customSpacing.sm),
                  decoration: BoxDecoration(
                    color: colors[index].withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icons[index], color: colors[index], size: 20),
                ),
                SizedBox(width: customSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titles[index],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitles[index],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textLight,
                  size: 16,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAnalyticsInsights(ThemeData theme, CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                '156',
                'Total Analyses',
                Icons.bar_chart,
                AppColors.primary,
                '+12% this week',
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildInsightCard(
                '94%',
                'Accuracy Rate',
                Icons.verified,
                AppColors.success,
                '+2% improvement',
              ),
            ),
          ],
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                '2.3s',
                'Avg Response',
                Icons.speed,
                AppColors.accent,
                '-0.5s faster',
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildInsightCard(
                '23',
                'Active Tools',
                Icons.build,
                AppColors.secondary,
                '4 new this month',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    String value,
    String label,
    IconData icon,
    Color color,
    String trend,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: AppColors.success, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trend,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.success,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAnalysis(int index) {
    // Navigate back to main navigation with analysis screen
    Navigator.pop(context);
    // Use callback to set the analysis screen index
    if (Navigator.canPop(context)) {
      Navigator.pop(context, index);
    }
  }

  void _quickTextAnalysis() {
    _navigateToAnalysis(5);
  }

  void _batchAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BatchProcessingScreen()),
    );
  }
}
