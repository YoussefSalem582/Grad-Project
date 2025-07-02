import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/core.dart';
import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmotionProvider>().refreshAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.dashboardGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildDashboardHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: _buildDashboardContent(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Enterprise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () =>
                    context.read<EmotionProvider>().refreshAllData(),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                tooltip: 'Refresh Dashboard',
              ),
              IconButton(
                onPressed: () => _showNotifications(context),
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                tooltip: 'Notifications',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            AppStrings.dashboardTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.todaysInsights,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickStats(),
          const SizedBox(height: 24),
          _buildConnectionStatus(),
          const SizedBox(height: 24),
          _buildTodaysOverview(),
          const SizedBox(height: 24),
          _buildCustomerSentimentCard(),
          const SizedBox(height: 24),
          _buildUrgentIssuesCard(),
          const SizedBox(height: 24),
          _buildTeamPerformancePreview(),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Active Sessions',
                '127',
                Icons.people,
                AppColors.accent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Avg. Response',
                '2.3m',
                Icons.timer,
                AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Satisfaction',
                '94.2%',
                Icons.sentiment_satisfied,
                AppColors.positive,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Urgent Issues',
                '3',
                Icons.priority_high,
                AppColors.urgent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      decoration: AppTheme.enterpriseCardDecoration(),
      child: const ConnectionStatusCard(),
    );
  }

  Widget _buildTodaysOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Customer Overview",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildOverviewMetric('Total Interactions', '1,247', '+12%', true),
          const SizedBox(height: 12),
          _buildOverviewMetric('Resolved Issues', '1,089', '+8%', true),
          const SizedBox(height: 12),
          _buildOverviewMetric('Escalated Cases', '23', '-15%', false),
          const SizedBox(height: 12),
          _buildOverviewMetric('Customer Satisfaction', '94.2%', '+2.1%', true),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(
    String title,
    String value,
    String change,
    bool isPositive,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isPositive
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            change,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSentimentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Customer Sentiment Analysis',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _navigateToAnalytics(),
                child: const Text('View Details'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSentimentBar('Positive', 0.68, AppColors.positive),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSentimentBar('Neutral', 0.24, AppColors.neutral),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSentimentBar('Negative', 0.08, AppColors.negative),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentBar(String label, double percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(percentage * 100).toInt()}%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgentIssuesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.warningGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.3),
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
              const Icon(Icons.warning_rounded, color: Colors.white),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Urgent Issues Requiring Attention',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _navigateToLiveMonitor(),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '3 customer issues require immediate escalation',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPerformancePreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Team Performance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _navigateToTeamPerformance(),
                child: const Text('View Teams'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTeamMetric(
            'Customer Service',
            '96%',
            AppColors.customerServiceTeam,
          ),
          const SizedBox(height: 12),
          _buildTeamMetric('Technical Support', '91%', AppColors.supportTeam),
          const SizedBox(height: 12),
          _buildTeamMetric('Sales Team', '89%', AppColors.salesTeam),
        ],
      ),
    );
  }

  Widget _buildTeamMetric(String teamName, String satisfaction, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            teamName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          satisfaction,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('No new notifications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _navigateToAnalytics() {
    // Navigate to analytics tab
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    }
    // This would normally use proper navigation
  }

  void _navigateToLiveMonitor() {
    // Navigate to live monitor tab
  }

  void _navigateToTeamPerformance() {
    // Navigate to team performance tab
  }
}
