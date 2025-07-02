import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';

class EmployeePerformanceScreen extends StatefulWidget {
  const EmployeePerformanceScreen({super.key});

  @override
  State<EmployeePerformanceScreen> createState() =>
      _EmployeePerformanceScreenState();
}

class _EmployeePerformanceScreenState extends State<EmployeePerformanceScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _chartController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _chartAnimation;

  String _selectedPeriod = 'This Month';
  int _selectedMetricIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutCubic,
    );

    _fadeController.forward();
    _chartController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _chartController.dispose();
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
        child: CustomScrollView(
          slivers: [
            // Hero Performance Header
            SliverToBoxAdapter(
              child: _buildPerformanceHero(theme, customSpacing),
            ),

            // Performance Overview Cards
            SliverToBoxAdapter(
              child: _buildPerformanceOverview(theme, customSpacing),
            ),

            // Advanced Metrics Dashboard
            SliverToBoxAdapter(
              child: _buildAdvancedMetrics(theme, customSpacing),
            ),

            // Performance Chart
            SliverToBoxAdapter(
              child: _buildInteractiveChart(theme, customSpacing),
            ),

            // Goals & Achievements
            SliverToBoxAdapter(child: _buildGoalsSection(theme, customSpacing)),

            // Performance Insights
            SliverToBoxAdapter(
              child: _buildPerformanceInsights(theme, customSpacing),
            ),

            // Rankings & Comparisons
            SliverToBoxAdapter(
              child: _buildRankingsSection(theme, customSpacing),
            ),

            SliverToBoxAdapter(child: SizedBox(height: customSpacing.xxl * 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceHero(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFF48CAE4)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(customSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(customSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(width: customSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Performance Dashboard',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Track your progress and achievements',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Period selector
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: customSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedPeriod,
                    dropdownColor: AppColors.surface,
                    underline: Container(),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    items:
                        [
                              'This Week',
                              'This Month',
                              'Last 3 Months',
                              'This Year',
                            ]
                            .map(
                              (period) => DropdownMenuItem(
                                value: period,
                                child: Text(period),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => _selectedPeriod = value!);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.xl),

            // Main performance score
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Overall Performance Score',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: customSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '92',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          const Text(
                            '/100',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: customSpacing.sm),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: customSpacing.sm,
                              vertical: customSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '+8 pts',
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: customSpacing.sm),
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.92,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                colors: [AppColors.success, AppColors.warning],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: customSpacing.lg),
                Expanded(
                  child: Column(
                    children: [
                      _buildMiniStat(
                        'Rank',
                        '#3',
                        '/25 employees',
                        customSpacing,
                      ),
                      SizedBox(height: customSpacing.md),
                      _buildMiniStat(
                        'Growth',
                        '+15%',
                        'vs last month',
                        customSpacing,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(
    String label,
    String value,
    String subtitle,
    CustomSpacing customSpacing,
  ) {
    return Container(
      padding: EdgeInsets.all(customSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceOverview(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Text(
                'Performance Overview',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.md,
            mainAxisSpacing: customSpacing.md,
            childAspectRatio: 1.4,
            children: [
              _buildPerformanceCard(
                'Customer Satisfaction',
                '4.9',
                '/5.0',
                Icons.sentiment_very_satisfied,
                AppColors.success,
                '+0.3 vs last period',
                customSpacing,
              ),
              _buildPerformanceCard(
                'Response Time',
                '1.8',
                'minutes',
                Icons.timer,
                AppColors.primary,
                '-15% improvement',
                customSpacing,
              ),
              _buildPerformanceCard(
                'Resolution Rate',
                '94',
                '%',
                Icons.check_circle,
                AppColors.warning,
                '+5% vs target',
                customSpacing,
              ),
              _buildPerformanceCard(
                'Quality Score',
                '87',
                '/100',
                Icons.star,
                AppColors.accent,
                'Excellent rating',
                customSpacing,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
    String trend,
    CustomSpacing customSpacing,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(customSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(customSpacing.sm),
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
                  child: Icon(icon, color: Colors.white, size: 20),
                ),

                const Spacer(),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1,
                      ),
                    ),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: customSpacing.xs),
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
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedMetrics(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Metrics Breakdown',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          // Metric selector tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMetricTab('Customer Focus', 0, customSpacing),
                _buildMetricTab('Efficiency', 1, customSpacing),
                _buildMetricTab('Quality', 2, customSpacing),
                _buildMetricTab('Growth', 3, customSpacing),
              ],
            ),
          ),
          SizedBox(height: customSpacing.lg),

          // Selected metric details
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildMetricDetails(_selectedMetricIndex, customSpacing),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTab(String title, int index, CustomSpacing customSpacing) {
    final isSelected = _selectedMetricIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedMetricIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: customSpacing.sm),
        padding: EdgeInsets.symmetric(
          horizontal: customSpacing.md,
          vertical: customSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildMetricDetails(int index, CustomSpacing customSpacing) {
    final metrics = [
      {
        'title': 'Customer Focus Metrics',
        'items': [
          {'name': 'Satisfaction Score', 'value': '4.9/5.0', 'progress': 0.98},
          {'name': 'Response Time', 'value': '1.8 min', 'progress': 0.85},
          {
            'name': 'First Contact Resolution',
            'value': '89%',
            'progress': 0.89,
          },
        ],
      },
      {
        'title': 'Efficiency Metrics',
        'items': [
          {'name': 'Cases Handled/Day', 'value': '24', 'progress': 0.92},
          {'name': 'Productivity Score', 'value': '87%', 'progress': 0.87},
          {'name': 'Time Management', 'value': '91%', 'progress': 0.91},
        ],
      },
      {
        'title': 'Quality Metrics',
        'items': [
          {'name': 'QA Score', 'value': '94%', 'progress': 0.94},
          {'name': 'Accuracy Rate', 'value': '96%', 'progress': 0.96},
          {'name': 'Documentation Quality', 'value': '88%', 'progress': 0.88},
        ],
      },
      {
        'title': 'Growth Metrics',
        'items': [
          {'name': 'Skill Development', 'value': '85%', 'progress': 0.85},
          {'name': 'Training Completion', 'value': '100%', 'progress': 1.0},
          {'name': 'Knowledge Sharing', 'value': '78%', 'progress': 0.78},
        ],
      },
    ];

    final metric = metrics[index];

    return Container(
      key: ValueKey(index),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric['title'] as String,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          ...(metric['items'] as List<Map<String, dynamic>>).map((item) {
            return _buildMetricItem(
              item['name'] as String,
              item['value'] as String,
              item['progress'] as double,
              customSpacing,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String name,
    String value,
    double progress,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.sm),
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: progress * _chartAnimation.value,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 0.9
                      ? AppColors.success
                      : progress >= 0.7
                      ? AppColors.warning
                      : AppColors.error,
                ),
                borderRadius: BorderRadius.circular(4),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveChart(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Performance Trend',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm,
                  vertical: customSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, color: AppColors.success, size: 16),
                    SizedBox(width: customSpacing.xs),
                    const Text(
                      'Trending Up',
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
          SizedBox(height: customSpacing.lg),

          // Chart placeholder with animated growth
          Container(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: PerformanceChartPainter(_chartAnimation.value),
                );
              },
            ),
          ),

          SizedBox(height: customSpacing.lg),

          // Chart legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartLegend('Performance', AppColors.primary),
              _buildChartLegend('Target', AppColors.warning),
              _buildChartLegend('Team Average', AppColors.textLight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsSection(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goals & Achievements',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          Container(
            padding: EdgeInsets.all(customSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildGoalItem(
                  'Complete 25 customer interactions',
                  22,
                  25,
                  AppColors.primary,
                  customSpacing,
                ),
                _buildGoalItem(
                  'Achieve 4.5+ satisfaction rating',
                  4.9,
                  4.5,
                  AppColors.success,
                  customSpacing,
                ),
                _buildGoalItem(
                  'Maintain <2min response time',
                  1.8,
                  2.0,
                  AppColors.success,
                  customSpacing,
                ),
                _buildGoalItem(
                  'Complete training modules',
                  8,
                  10,
                  AppColors.warning,
                  customSpacing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(
    String title,
    double current,
    double target,
    Color color,
    CustomSpacing customSpacing,
  ) {
    final progress = (current / target).clamp(0.0, 1.0);
    final isCompleted = current >= target;

    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success
                      : color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.radio_button_unchecked,
                  color: isCompleted ? Colors.white : color,
                  size: 16,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isCompleted
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Text(
                '${current.toStringAsFixed(current % 1 == 0 ? 0 : 1)}/${target.toStringAsFixed(target % 1 == 0 ? 0 : 1)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isCompleted ? AppColors.success : color,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.sm),
          Padding(
            padding: EdgeInsets.only(left: customSpacing.lg),
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: progress * _chartAnimation.value,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? AppColors.success : color,
                  ),
                  borderRadius: BorderRadius.circular(4),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInsights(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.accent.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(customSpacing.sm),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Text(
                'AI Performance Insights',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.lg),

          const Text(
            'Excellent work this period! You\'re performing 15% above team average. Your customer satisfaction scores are consistently high, and your response times have improved significantly.',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          SizedBox(height: customSpacing.md),

          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_up, color: AppColors.warning, size: 20),
                SizedBox(width: customSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Improvement Opportunity',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                      const Text(
                        'Focus on completing remaining training modules to unlock advanced features.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: customSpacing.lg),

          ModernButton(
            onPressed: () {},
            style: ModernButtonStyle.primary,
            text: 'View Detailed Report',
            icon: Icons.assessment,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingsSection(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Rankings',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          Container(
            padding: EdgeInsets.all(customSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildRankingItem('You', '92', '#3', true, customSpacing),
                _buildRankingItem(
                  'Sarah Johnson',
                  '95',
                  '#1',
                  false,
                  customSpacing,
                ),
                _buildRankingItem(
                  'Mike Chen',
                  '94',
                  '#2',
                  false,
                  customSpacing,
                ),
                _buildRankingItem(
                  'Emily Davis',
                  '89',
                  '#4',
                  false,
                  customSpacing,
                ),
                _buildRankingItem(
                  'Robert Wilson',
                  '87',
                  '#5',
                  false,
                  customSpacing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingItem(
    String name,
    String score,
    String rank,
    bool isCurrentUser,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrentUser
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _getRankColor(rank),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                rank,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w600,
                color: isCurrentUser
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            score,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _getRankColor(rank),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(String rank) {
    switch (rank) {
      case '#1':
        return AppColors.warning; // Gold
      case '#2':
        return AppColors.textLight; // Silver
      case '#3':
        return AppColors.accent; // Bronze
      default:
        return AppColors.textSecondary;
    }
  }
}

// Custom painter for performance chart
class PerformanceChartPainter extends CustomPainter {
  final double animationValue;

  PerformanceChartPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Performance line
    paint.color = AppColors.primary;
    final performancePath = Path();
    final performancePoints = [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.9];

    for (int i = 0; i < performancePoints.length; i++) {
      final x = (size.width / (performancePoints.length - 1)) * i;
      final y =
          size.height - (performancePoints[i] * size.height * animationValue);

      if (i == 0) {
        performancePath.moveTo(x, y);
      } else {
        performancePath.lineTo(x, y);
      }
    }
    canvas.drawPath(performancePath, paint);

    // Target line
    paint.color = AppColors.warning;
    paint.strokeWidth = 2;
    final targetY = size.height - (0.75 * size.height);
    canvas.drawLine(
      Offset(0, targetY),
      Offset(size.width * animationValue, targetY),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
