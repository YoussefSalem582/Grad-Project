import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../screens/employee/employee_dashboard_screen/widgets/employee_analytics_card.dart';
import '../../../cubit/employee_analytics/employee_analytics_cubit.dart';

class MetricsGrid extends StatelessWidget {
  final CustomSpacing customSpacing;
  final Animation<double> animation;

  const MetricsGrid({
    super.key,
    required this.customSpacing,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeAnalyticsCubit, EmployeeAnalyticsState>(
      builder: (context, state) {
        if (state is EmployeeAnalyticsSuccess) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: customSpacing.md,
            mainAxisSpacing: customSpacing.md,
            childAspectRatio: 1.3,
            children:
                state.data.metrics
                    .map(
                      (metric) => EmployeeAnalyticsCard(
                        title: metric['title'],
                        value: metric['value'],
                        unit: metric['unit'],
                        icon: _getIconForMetric(metric['title']),
                        color: _getColorForMetric(metric['title']),
                        trend: metric['trend'],
                        isPositiveTrend: metric['isPositiveTrend'],
                      ),
                    )
                    .toList(),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  IconData _getIconForMetric(String title) {
    switch (title) {
      case 'Ticket Volume':
        return Icons.assignment;
      case 'Resolution Rate':
        return Icons.check_circle;
      case 'Customer Satisfaction':
        return Icons.star;
      case 'Tickets Handled':
        return Icons.assignment;
      case 'First Resolution':
        return Icons.speed;
      case 'Customer Escalations':
        return Icons.trending_up;
      default:
        return Icons.analytics;
    }
  }

  Color _getColorForMetric(String title) {
    switch (title) {
      case 'Ticket Volume':
        return AppColors.primary;
      case 'Resolution Rate':
        return AppColors.success;
      case 'Customer Satisfaction':
        return AppColors.warning;
      case 'Tickets Handled':
        return AppColors.info;
      case 'First Resolution':
        return const Color(0xFF9C27B0);
      case 'Customer Escalations':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}
