import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../core/core.dart';
import '../../providers/providers.dart';

import '../../widgets/widgets.dart';

class CustomerAnalyticsScreen extends StatefulWidget {
  const CustomerAnalyticsScreen({super.key});

  @override
  State<CustomerAnalyticsScreen> createState() =>
      _CustomerAnalyticsScreenState();
}

class _CustomerAnalyticsScreenState extends State<CustomerAnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedTimeframe = 'Today';
  final List<String> _timeframes = ['Today', 'Week', 'Month', 'Quarter'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.customerAnalytics),
        actions: [
          IconButton(
            onPressed: () => _exportReport(),
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export Report',
          ),
          IconButton(
            onPressed: () => context.read<EmotionProvider>().refreshAllData(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildAnalyticsHeader(),
          _buildTabBar(),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildAnalyticsHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Customer Sentiment Analysis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _selectedTimeframe,
                  onChanged: (value) =>
                      setState(() => _selectedTimeframe = value!),
                  underline: const SizedBox(),
                  items: _timeframes.map((timeframe) {
                    return DropdownMenuItem(
                      value: timeframe,
                      child: Text(
                        timeframe,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Analyze customer feedback and sentiment trends across all touchpoints',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.accent,
        labelColor: AppColors.accent,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        tabs: const [
          Tab(icon: Icon(Icons.analytics), text: 'Real-time Analysis'),
          Tab(icon: Icon(Icons.trending_up), text: 'Trends & Insights'),
          Tab(icon: Icon(Icons.pie_chart), text: 'Sentiment Distribution'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      color: AppColors.background,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildRealTimeAnalysisTab(),
          _buildTrendsTab(),
          _buildDistributionTab(),
        ],
      ),
    );
  }

  Widget _buildRealTimeAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomerFeedbackInput(),
          const SizedBox(height: 24),
          Consumer<EmotionProvider>(
            builder: (context, provider, child) {
              if (provider.emotionResult != null) {
                return _buildAnalysisResults(provider);
              }
              return _buildRecentAnalyses();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerFeedbackInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Analyze Customer Feedback',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _feedbackController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: AppStrings.inputHint,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _analyzeFeedback(),
                  icon: const Icon(Icons.psychology),
                  label: const Text(AppStrings.analyzeCustomerFeedback),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _showSampleFeedback(),
                icon: const Icon(Icons.lightbulb_outline),
                tooltip: 'Show Sample Feedback',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisResults(EmotionProvider provider) {
    return Container(
      decoration: AppTheme.enterpriseCardDecoration(),
      child: const ResultsCard(),
    );
  }

  Widget _buildRecentAnalyses() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Customer Feedback Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentAnalysisItem(
            'Customer support was extremely helpful with my billing issue',
            'joy',
            'positive',
            0.89,
            '2 minutes ago',
          ),
          const Divider(),
          _buildRecentAnalysisItem(
            'The delivery was delayed again, this is frustrating',
            'anger',
            'negative',
            0.76,
            '8 minutes ago',
          ),
          const Divider(),
          _buildRecentAnalysisItem(
            'The product quality is okay, nothing special',
            'neutral',
            'neutral',
            0.67,
            '15 minutes ago',
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAnalysisItem(
    String feedback,
    String emotion,
    String sentiment,
    double confidence,
    String time,
  ) {
    Color sentimentColor = sentiment == 'positive'
        ? AppColors.positive
        : sentiment == 'negative'
        ? AppColors.negative
        : AppColors.neutral;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feedback,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sentimentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  sentiment.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: sentimentColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(confidence * 100).toInt()}% confident',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildSentimentTrendCard(),
          const SizedBox(height: 24),
          _buildTopIssuesCard(),
          const SizedBox(height: 24),
          _buildCustomerSatisfactionTrendCard(),
        ],
      ),
    );
  }

  Widget _buildSentimentTrendCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sentiment Trend Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Sentiment Trend Chart\n(Chart implementation would go here)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopIssuesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Customer Issues',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildIssueItem('Delivery Delays', 43, AppColors.negative),
          const SizedBox(height: 12),
          _buildIssueItem('Billing Issues', 28, AppColors.warning),
          const SizedBox(height: 12),
          _buildIssueItem('Product Quality', 19, AppColors.warning),
          const SizedBox(height: 12),
          _buildIssueItem('Account Access', 12, AppColors.info),
        ],
      ),
    );
  }

  Widget _buildIssueItem(String issue, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            issue,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSatisfactionTrendCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Satisfaction Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSatisfactionMetric(
                  'Current',
                  '94.2%',
                  '+2.1%',
                  true,
                ),
              ),
              Expanded(
                child: _buildSatisfactionMetric(
                  'Weekly Avg',
                  '92.1%',
                  '+1.8%',
                  true,
                ),
              ),
              Expanded(
                child: _buildSatisfactionMetric(
                  'Monthly Avg',
                  '90.3%',
                  '+3.2%',
                  true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSatisfactionMetric(
    String label,
    String value,
    String change,
    bool isPositive,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
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
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isPositive ? AppColors.success : AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildEmotionDistributionCard(),
          const SizedBox(height: 24),
          _buildSentimentByChannelCard(),
          const SizedBox(height: 24),
          _buildCustomerSegmentCard(),
        ],
      ),
    );
  }

  Widget _buildEmotionDistributionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emotion Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'Emotion Distribution Chart\n(Pie chart implementation would go here)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentByChannelCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sentiment by Channel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildChannelSentiment('Email Support', 0.89, AppColors.positive),
          const SizedBox(height: 12),
          _buildChannelSentiment('Live Chat', 0.94, AppColors.positive),
          const SizedBox(height: 12),
          _buildChannelSentiment('Phone Support', 0.87, AppColors.positive),
          const SizedBox(height: 12),
          _buildChannelSentiment('Social Media', 0.72, AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildChannelSentiment(String channel, double score, Color color) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            channel,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: score,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(score * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerSegmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Segment Analysis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Premium customers show 12% higher satisfaction rates compared to standard customers. New customers require 18% more support interactions on average.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _analyzeFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.emptyTextError)));
      return;
    }

    context.read<EmotionProvider>().analyzeEmotion(
      _feedbackController.text.trim(),
    );
  }

  void _showSampleFeedback() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sample Customer Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AppStrings.customerServiceExamples.map((example) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: GestureDetector(
                onTap: () {
                  _feedbackController.text = example
                      .replaceAll(RegExp(r'^[^\s]+\s'), '')
                      .replaceAll('"', '');
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(example, style: const TextStyle(fontSize: 14)),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report export feature coming soon')),
    );
  }
}

