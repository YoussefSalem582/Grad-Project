import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class PerformanceTrendsChart extends StatelessWidget {
  final ThemeData theme;
  final CustomSpacing customSpacing;
  final Animation<double> chartAnimation;
  final int selectedMetricIndex;
  final ValueChanged<int> onMetricChanged;

  const PerformanceTrendsChart({
    super.key,
    required this.theme,
    required this.customSpacing,
    required this.chartAnimation,
    required this.selectedMetricIndex,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Enhanced Performance Chart
        Container(
          height: 300,
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
              Row(
                children: [
                  Text(
                    'Performance Trends',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  _buildMetricSelector(),
                ],
              ),
              SizedBox(height: customSpacing.lg),
              Expanded(child: _buildChart()),
            ],
          ),
        ),
        SizedBox(height: customSpacing.md),

        // Performance Summary Cards
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Best Day',
                'Wednesday',
                '+12%',
                AppColors.success,
                Icons.calendar_today,
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildSummaryCard(
                'Peak Hour',
                '2-3 PM',
                '23 tickets',
                AppColors.primary,
                Icons.access_time,
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: _buildSummaryCard(
                'Avg Resolution',
                '2.1h',
                'per ticket',
                AppColors.info,
                Icons.timer,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricSelector() {
    final metrics = [
      'Ticket Volume',
      'Satisfaction',
      'Resolution Rate',
      'Efficiency',
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedMetricIndex,
          style: const TextStyle(color: Colors.black, fontSize: 12),
          items: metrics
              .asMap()
              .entries
              .map(
                (entry) => DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              onMetricChanged(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Animated chart bars
          ...List.generate(7, (index) {
            final progress = (0.3 + (index * 0.1)) * chartAnimation.value;
            final height = 40 + (progress * 120);
            return Positioned(
              left: 30 + (index * 35),
              bottom: 20,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600 + (index * 100)),
                width: 12,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(6),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Day labels
          ...List.generate(7, (index) {
            final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            return Positioned(
              left: 26 + (index * 35),
              bottom: 4,
              child: Text(
                days[index],
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }),

          // Trend line overlay
          CustomPaint(
            size: const Size(double.infinity, double.infinity),
            painter: _TrendLinePainter(chartAnimation.value),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    return Container(
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
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              SizedBox(width: customSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendLinePainter extends CustomPainter {
  final double animationValue;

  _TrendLinePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Create smooth upward trending line
    final points = [
      Offset(36, size.height * 0.75),
      Offset(size.width * 0.25, size.height * 0.65),
      Offset(size.width * 0.45, size.height * 0.45),
      Offset(size.width * 0.65, size.height * 0.35),
      Offset(size.width * 0.85, size.height * 0.25),
    ];

    if (points.isNotEmpty) {
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < points.length; i++) {
        final current = points[i];
        final previous = points[i - 1];

        final controlPoint1 = Offset(
          previous.dx + (current.dx - previous.dx) * 0.5,
          previous.dy,
        );
        final controlPoint2 = Offset(
          previous.dx + (current.dx - previous.dx) * 0.5,
          current.dy,
        );

        // Only draw up to animation progress
        final animatedX = current.dx * animationValue;
        if (animatedX >= previous.dx) {
          path.cubicTo(
            controlPoint1.dx,
            controlPoint1.dy,
            controlPoint2.dx,
            controlPoint2.dy,
            animatedX,
            current.dy,
          );
        }
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrendLinePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
