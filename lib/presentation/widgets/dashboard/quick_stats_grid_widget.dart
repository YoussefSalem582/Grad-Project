import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../cubit/employee_dashboard/employee_dashboard_cubit.dart';

class QuickStatsGridWidget extends StatelessWidget {
  final EmployeeDashboardData? data;

  const QuickStatsGridWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    // Create default stats structure with proper fallbacks
    final stats = [
      {
        'title': 'Tickets Resolved',
        'value': '${data?.ticketsResolved ?? 24}',
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
      {
        'title': 'Active Tickets',
        'value': '${data?.activeTickets ?? 5}',
        'icon': Icons.assignment_outlined,
        'color': AppColors.primary,
      },
      {
        'title': 'Customer Rating',
        'value': '${(data?.customerSatisfaction ?? 4.8).toStringAsFixed(1)}/5',
        'icon': Icons.star,
        'color': AppColors.warning,
      },
      {
        'title': 'Efficiency Score',
        'value': '${data?.efficiencyScore ?? 94}%',
        'icon': Icons.trending_up,
        'color': AppColors.info,
      },
    ];

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: customSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return _StatCard(
                title: stat['title'] as String,
                value: stat['value'] as String,
                icon: stat['icon'] as IconData,
                color: stat['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
