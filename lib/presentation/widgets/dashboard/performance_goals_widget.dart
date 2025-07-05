import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../cubit/employee_dashboard/employee_dashboard_cubit.dart';

class PerformanceGoalsWidget extends StatelessWidget {
  final EmployeeDashboardData? data;

  const PerformanceGoalsWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Goals',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: customSpacing.md),
          Container(
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _GoalItem(
                  title: 'Resolve 8 tickets',
                  current: (data?.ticketsResolved ?? 6).toDouble(),
                  target: 8,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                _GoalItem(
                  title: 'Maintain 4.5+ rating',
                  current: (data?.customerSatisfaction ?? 4.8) * 0.9,
                  target: 4.5,
                  color: AppColors.success,
                ),
                const SizedBox(height: 16),
                _GoalItem(
                  title: 'Response time <2h',
                  current: 1.8,
                  target: 2.0,
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final Color color;

  const _GoalItem({
    required this.title,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (current / target).clamp(0.0, 1.0);
    bool isCompleted = current >= target;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.1)
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                  if (isCompleted) const SizedBox(width: 4),
                  Text(
                    '${current.toStringAsFixed(1)}/${target.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? AppColors.success : color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            isCompleted ? AppColors.success : color,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
