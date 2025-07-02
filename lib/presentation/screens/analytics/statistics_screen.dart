import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

import '../../../core/core.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Week';
  final List<String> _periods = ['Day', 'Week', 'Month', 'Year'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildPeriodSelector(),
              _buildTabBar(),
              Expanded(child: _buildTabContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Detailed insights and trends',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.read<EmotionProvider>().refreshAllData(),
            icon: const Icon(Icons.refresh, color: Colors.white, size: 24),
            tooltip: 'Refresh data',
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: _periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.3)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: const [
          Tab(icon: Icon(Icons.show_chart), text: 'Trends'),
          Tab(icon: Icon(Icons.pie_chart), text: 'Distribution'),
          Tab(icon: Icon(Icons.speed), text: 'Performance'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildTrendsTab(),
            _buildDistributionTab(),
            _buildPerformanceTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        children: [
          _buildEmotionTrendsCard(),
          const SizedBox(height: 24),
          _buildConfidenceTrendCard(),
          const SizedBox(height: 24),
          _buildUsageTrendCard(),
        ],
      ),
    );
  }

  Widget _buildDistributionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildEmotionDistributionCard(provider),
              const SizedBox(height: 24),
              _buildSentimentDistributionCard(provider),
              const SizedBox(height: 24),
              _buildTimeDistributionCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Consumer<EmotionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildSystemPerformanceCard(provider),
              const SizedBox(height: 24),
              _buildApiPerformanceCard(provider),
              const SizedBox(height: 24),
              _buildAccuracyMetricsCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmotionTrendsCard() {
    return _buildStatCard(
      title: 'Emotion Trends',
      subtitle: 'How emotions change over $_selectedPeriod',
      icon: Icons.trending_up,
      color: AppColors.primary,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Trend Chart\n(Interactive chart coming soon)',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceTrendCard() {
    return _buildStatCard(
      title: 'Confidence Trend',
      subtitle: 'Analysis accuracy over time',
      icon: Icons.precision_manufacturing,
      color: AppColors.success,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('Average', '87.3%', AppColors.success),
              _buildMiniStat('Highest', '98.5%', AppColors.primary),
              _buildMiniStat('Lowest', '64.2%', AppColors.warning),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Confidence Chart',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageTrendCard() {
    return _buildStatCard(
      title: 'Usage Patterns',
      subtitle: 'When you use the app most',
      icon: Icons.schedule,
      color: AppColors.accent,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('Peak Hour', '2 PM', AppColors.accent),
              _buildMiniStat('Avg/Day', '12.5', AppColors.primary),
              _buildMiniStat('Total', '847', AppColors.success),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Usage Heatmap',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionDistributionCard(EmotionProvider provider) {
    final analytics = provider.analyticsSummary;
    return _buildStatCard(
      title: 'Emotion Distribution',
      subtitle: 'Breakdown by emotion type',
      icon: Icons.pie_chart,
      color: AppColors.primary,
      child: analytics?.emotionCounts.isNotEmpty == true
          ? Column(
              children: analytics!.emotionCounts.entries.map((entry) {
                final percentage = analytics.totalAnalyses > 0
                    ? (entry.value / analytics.totalAnalyses) * 100
                    : 0.0;
                return _buildProgressBar(
                  entry.key,
                  entry.value,
                  percentage,
                  EmotionUtils.getEmotionColor(entry.key),
                );
              }).toList(),
            )
          : const Center(
              child: Text(
                'No emotion data available',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
    );
  }

  Widget _buildSentimentDistributionCard(EmotionProvider provider) {
    final analytics = provider.analyticsSummary;
    return _buildStatCard(
      title: 'Sentiment Analysis',
      subtitle: 'Overall sentiment breakdown',
      icon: Icons.sentiment_satisfied,
      color: AppColors.accent,
      child: analytics?.sentimentCounts.isNotEmpty == true
          ? Column(
              children: analytics!.sentimentCounts.entries.map((entry) {
                final percentage = analytics.totalAnalyses > 0
                    ? (entry.value / analytics.totalAnalyses) * 100
                    : 0.0;
                return _buildProgressBar(
                  entry.key,
                  entry.value,
                  percentage,
                  _getSentimentColor(entry.key),
                );
              }).toList(),
            )
          : const Center(
              child: Text(
                'No sentiment data available',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
    );
  }

  Widget _buildTimeDistributionCard() {
    return _buildStatCard(
      title: 'Time Distribution',
      subtitle: 'Analysis frequency by time of day',
      icon: Icons.access_time,
      color: AppColors.warning,
      child: Column(
        children: [
          _buildTimeSlot('Morning (6-12)', 45, AppColors.warning),
          _buildTimeSlot('Afternoon (12-18)', 67, AppColors.primary),
          _buildTimeSlot('Evening (18-24)', 32, AppColors.accent),
          _buildTimeSlot('Night (0-6)', 8, AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildSystemPerformanceCard(EmotionProvider provider) {
    final metrics = provider.systemMetrics;
    return _buildStatCard(
      title: 'System Performance',
      subtitle: 'Backend system health metrics',
      icon: Icons.monitor_heart,
      color: AppColors.success,
      child: metrics != null
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStat(
                      'CPU',
                      metrics.cpuUsageFormatted,
                      AppColors.primary,
                    ),
                    _buildMiniStat(
                      'Memory',
                      metrics.memoryUsageFormatted,
                      AppColors.accent,
                    ),
                    _buildMiniStat('Uptime', metrics.uptime, AppColors.success),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProgressBar(
                  'Success Rate',
                  metrics.successfulRequests,
                  metrics.successRate,
                  AppColors.success,
                ),
              ],
            )
          : const Center(
              child: Text(
                'Loading system metrics...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
    );
  }

  Widget _buildApiPerformanceCard(EmotionProvider provider) {
    final analytics = provider.analyticsSummary;
    return _buildStatCard(
      title: 'API Performance',
      subtitle: 'Request processing statistics',
      icon: Icons.api,
      color: AppColors.info,
      child: analytics?.performanceStats != null
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMiniStat(
                      'Avg Time',
                      analytics!
                          .performanceStats
                          .averageProcessingTimeFormatted,
                      AppColors.info,
                    ),
                    _buildMiniStat(
                      'Success',
                      analytics.performanceStats.successRateFormatted,
                      AppColors.success,
                    ),
                    _buildMiniStat(
                      'Total',
                      analytics.performanceStats.totalRequests.toString(),
                      AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: analytics.performanceStats.successRate,
                  backgroundColor: AppColors.info.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
                ),
              ],
            )
          : const Center(
              child: Text(
                'Loading API metrics...',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
    );
  }

  Widget _buildAccuracyMetricsCard() {
    return _buildStatCard(
      title: 'Model Accuracy',
      subtitle: 'AI model performance metrics',
      icon: Icons.model_training,
      color: AppColors.warning,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('Precision', '94.2%', AppColors.success),
              _buildMiniStat('Recall', '91.8%', AppColors.primary),
              _buildMiniStat('F1-Score', '93.0%', AppColors.accent),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Model Training Data',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDataPoint('Samples', '2.1M'),
                    _buildDataPoint('Languages', '7'),
                    _buildDataPoint('Accuracy', '95.8%'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.1), AppColors.surface],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildProgressBar(
    String label,
    int count,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$count (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String timeSlot, int count, Color color) {
    const maxCount = 100;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              timeSlot,
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: count / maxCount,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataPoint(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.warning,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }
}

