import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class DetailedAnalytics extends StatelessWidget {
  final ThemeData theme;
  final CustomSpacing customSpacing;
  final Animation<double> cardAnimation;

  const DetailedAnalytics({
    super.key,
    required this.theme,
    required this.customSpacing,
    required this.cardAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analytics',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: customSpacing.md),

        Row(
          children: [
            Expanded(child: _buildTicketTypeBreakdown()),
            SizedBox(width: customSpacing.md),
            Expanded(child: _buildPriorityDistribution()),
          ],
        ),
        SizedBox(height: customSpacing.md),

        _buildResponseTimeBreakdown(),
      ],
    );
  }

  Widget _buildTicketTypeBreakdown() {
    return Container(
      height: 220,
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ticket Types',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: customSpacing.md),
          Expanded(
            child: Column(
              children: [
                _buildTypeBar('Product Issues', 0.45, AppColors.error),
                _buildTypeBar('Shipping', 0.25, AppColors.warning),
                _buildTypeBar('Account', 0.20, AppColors.info),
                _buildTypeBar('Other', 0.10, AppColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityDistribution() {
    return Container(
      height: 220,
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Priority Distribution',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: customSpacing.md),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.32 * cardAnimation.value,
                      strokeWidth: 15,
                      backgroundColor: Colors.grey[200],
                      color: AppColors.error,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '32%',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'High Priority',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Priority legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriorityLegend('High', AppColors.error, '32%'),
              _buildPriorityLegend('Medium', AppColors.warning, '48%'),
              _buildPriorityLegend('Low', AppColors.success, '20%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityLegend(String label, Color color, String percentage) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            color: color,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTimeBreakdown() {
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
          const Text(
            'Ticket Resolution Speed',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: customSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildTimeMetric('Same Day', '45%', AppColors.success),
              ),
              Expanded(
                child: _buildTimeMetric('1-2 Days', '35%', AppColors.warning),
              ),
              Expanded(
                child: _buildTimeMetric('3-5 Days', '15%', AppColors.error),
              ),
              Expanded(child: _buildTimeMetric('> 5 Days', '5%', Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBar(String label, double percentage, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.xs),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage * cardAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMetric(String timeRange, String percentage, Color color) {
    return Column(
      children: [
        Text(
          percentage,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          timeRange,
          style: const TextStyle(color: Colors.black54, fontSize: 10),
        ),
      ],
    );
  }
}
