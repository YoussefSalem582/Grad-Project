import 'package:flutter/material.dart';
import 'dart:async';


import '../../../core/core.dart';

class LiveMonitorScreen extends StatefulWidget {
  const LiveMonitorScreen({super.key});

  @override
  State<LiveMonitorScreen> createState() => _LiveMonitorScreenState();
}

class _LiveMonitorScreenState extends State<LiveMonitorScreen> {
  Timer? _updateTimer;
  bool _isAutoRefresh = true;
  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Urgent',
    'Escalated',
    'Positive',
    'Negative',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    if (_isAutoRefresh) {
      _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
        if (mounted) {
          setState(() {
            // Refresh data
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.realTimeMonitoring),
        actions: [
          IconButton(
            onPressed: () => _toggleAutoRefresh(),
            icon: Icon(
              _isAutoRefresh
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
            ),
            tooltip: _isAutoRefresh
                ? 'Pause Auto-refresh'
                : 'Start Auto-refresh',
          ),
          IconButton(
            onPressed: () => _manualRefresh(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Manual Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildLiveHeader(),
          _buildFilterBar(),
          Expanded(child: _buildLiveContent()),
        ],
      ),
    );
  }

  Widget _buildLiveHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.primaryGradient),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Last updated: ${DateTime.now().toString().substring(11, 19)}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Real-time Customer Monitoring',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor customer interactions and sentiment in real-time',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          _buildLiveStats(),
        ],
      ),
    );
  }

  Widget _buildLiveStats() {
    return Row(
      children: [
        Expanded(
          child: _buildLiveStatItem('Active Sessions', '127', AppColors.accent),
        ),
        Expanded(
          child: _buildLiveStatItem('Urgent Issues', '3', AppColors.urgent),
        ),
        Expanded(
          child: _buildLiveStatItem(
            'Avg. Sentiment',
            '+0.82',
            AppColors.positive,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            'Filter:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      backgroundColor: Colors.transparent,
                      selectedColor: AppColors.accent.withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 12,
                      ),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textLight,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveContent() {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildUrgentAlertsCard(),
            const SizedBox(height: 24),
            _buildRealtimeFeedbackCard(),
            const SizedBox(height: 24),
            _buildActiveSessionsCard(),
            const SizedBox(height: 24),
            _buildEscalationQueueCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentAlertsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.errorGradient),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.3),
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
              const Icon(Icons.warning_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Urgent Alerts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildUrgentAlertItem(
            'Customer extremely frustrated with delayed order #12345',
            'Sarah Johnson',
            '2 minutes ago',
            'High Priority',
          ),
          const SizedBox(height: 12),
          _buildUrgentAlertItem(
            'Multiple complaints about payment processing errors',
            'Mike Chen',
            '5 minutes ago',
            'Critical',
          ),
          const SizedBox(height: 12),
          _buildUrgentAlertItem(
            'Customer threatening to cancel premium subscription',
            'Emily Davis',
            '8 minutes ago',
            'High Priority',
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentAlertItem(
    String message,
    String agent,
    String time,
    String priority,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Agent: $agent',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeFeedbackCard() {
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
                  'Real-time Customer Feedback',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fiber_manual_record,
                  color: Colors.white,
                  size: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFeedbackItem(
            'Thank you so much for the quick resolution!',
            'positive',
            '30 seconds ago',
            'Email Support',
          ),
          const Divider(),
          _buildFeedbackItem(
            'This is taking way too long to resolve...',
            'negative',
            '1 minute ago',
            'Live Chat',
          ),
          const Divider(),
          _buildFeedbackItem(
            'The new feature works perfectly, great job!',
            'positive',
            '2 minutes ago',
            'App Review',
          ),
          const Divider(),
          _buildFeedbackItem(
            'Can you help me understand how this works?',
            'neutral',
            '3 minutes ago',
            'Phone Support',
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(
    String feedback,
    String sentiment,
    String time,
    String channel,
  ) {
    Color sentimentColor = sentiment == 'positive'
        ? AppColors.positive
        : sentiment == 'negative'
        ? AppColors.negative
        : AppColors.neutral;

    IconData sentimentIcon = sentiment == 'positive'
        ? Icons.sentiment_satisfied
        : sentiment == 'negative'
        ? Icons.sentiment_dissatisfied
        : Icons.sentiment_neutral;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(sentimentIcon, color: sentimentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      channel,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Customer Sessions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSessionItem(
            'Alex Rodriguez',
            'Billing Issue',
            '12:34',
            'In Progress',
            AppColors.warning,
          ),
          const SizedBox(height: 8),
          _buildSessionItem(
            'Jessica Wong',
            'Technical Support',
            '15:22',
            'Waiting',
            AppColors.info,
          ),
          const SizedBox(height: 8),
          _buildSessionItem(
            'David Kim',
            'Account Access',
            '8:45',
            'Resolved',
            AppColors.success,
          ),
          const SizedBox(height: 8),
          _buildSessionItem(
            'Lisa Thompson',
            'Product Inquiry',
            '23:12',
            'Escalated',
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(
    String agent,
    String issue,
    String duration,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.accent,
            child: Text(
              agent.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agent,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  issue,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                duration,
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

  Widget _buildEscalationQueueCard() {
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
                  'Escalation Queue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '2 pending',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEscalationItem(
            'Payment processing failure - Customer VIP',
            'Case #12345',
            'Manager Review Required',
            '15 minutes ago',
          ),
          const SizedBox(height: 12),
          _buildEscalationItem(
            'Service outage complaint - Multiple customers',
            'Case #12346',
            'Technical Team Required',
            '22 minutes ago',
          ),
        ],
      ),
    );
  }

  Widget _buildEscalationItem(
    String title,
    String caseId,
    String requirement,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                caseId,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  requirement,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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

  void _toggleAutoRefresh() {
    setState(() {
      _isAutoRefresh = !_isAutoRefresh;
      if (_isAutoRefresh) {
        _startAutoRefresh();
      } else {
        _updateTimer?.cancel();
      }
    });
  }

  void _manualRefresh() {
    setState(() {
      // Refresh data manually
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data refreshed')));
  }
}

