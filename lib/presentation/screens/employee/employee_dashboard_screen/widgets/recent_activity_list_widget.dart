import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

// Using dynamic data type until cubit is implemented
class RecentActivityListWidget extends StatelessWidget {
  final dynamic data;

  const RecentActivityListWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    final activities =
        data?.recentTickets ??
        [
          {
            'ticket': '#TICK-001',
            'customer': 'John Doe',
            'status': 'Resolved',
            'time': '2h ago',
          },
          {
            'ticket': '#TICK-002',
            'customer': 'Jane Smith',
            'status': 'In Progress',
            'time': '1h ago',
          },
          {
            'ticket': '#TICK-003',
            'customer': 'Mike Johnson',
            'status': 'Open',
            'time': '30m ago',
          },
        ];

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Navigate to full activity list
                },
                child: Text(
                  'View All',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(color: AppColors.surfaceVariant, height: 1),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _ActivityItem(
                  ticket: activity['ticket'] as String? ?? '#TICK-${index + 1}',
                  customer:
                      activity['customer'] as String? ??
                      'Customer ${index + 1}',
                  status: activity['status'] as String? ?? 'Open',
                  time: activity['time'] as String? ?? 'Just now',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String ticket;
  final String customer;
  final String status;
  final String time;

  const _ActivityItem({
    required this.ticket,
    required this.customer,
    required this.status,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(status);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(_getStatusIcon(status), color: statusColor, size: 24),
      ),
      title: Text(
        '$ticket - $customer',
        style: theme.textTheme.titleSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        time,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          status,
          style: theme.textTheme.labelSmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.primary;
      case 'in progress':
        return AppColors.warning;
      case 'resolved':
        return AppColors.success;
      case 'high':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Icons.radio_button_unchecked;
      case 'in progress':
        return Icons.access_time;
      case 'resolved':
        return Icons.check_circle;
      case 'high':
        return Icons.priority_high;
      default:
        return Icons.help_outline;
    }
  }
}
