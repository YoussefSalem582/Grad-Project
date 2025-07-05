import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class GoalsAndTargets extends StatelessWidget {
  final ThemeData theme;
  final CustomSpacing customSpacing;
  final Animation<double> cardAnimation;

  const GoalsAndTargets({
    super.key,
    required this.theme,
    required this.customSpacing,
    required this.cardAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Goals & Targets',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          _buildGoalProgress('Ticket Efficiency', 0.87, '> 85%', '87% current'),
          SizedBox(height: customSpacing.md),
          _buildGoalProgress('Resolution Rate', 0.94, '> 90%', '94% current'),
          SizedBox(height: customSpacing.md),
          _buildGoalProgress(
            'Customer Satisfaction',
            0.96,
            '> 4.5/5',
            '4.8/5 current',
          ),
          SizedBox(height: customSpacing.md),
          _buildGoalProgress(
            'Daily Tickets',
            0.75,
            '20 tickets',
            '15 completed today',
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(
    String title,
    double progress,
    String target,
    String current,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              target,
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: customSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress * cardAnimation.value,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.9
                  ? AppColors.success
                  : progress >= 0.7
                  ? AppColors.warning
                  : AppColors.error,
            ),
            minHeight: 6,
          ),
        ),
        SizedBox(height: customSpacing.xs),
        Text(
          current,
          style: TextStyle(
            color: progress >= 0.9
                ? AppColors.success
                : progress >= 0.7
                ? AppColors.warning
                : AppColors.error,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
