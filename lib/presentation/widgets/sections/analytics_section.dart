import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import 'analytics/analytics_header.dart';
import 'analytics/metrics_grid.dart';
import 'analytics/performance_trends_chart.dart';
import 'analytics/detailed_analytics.dart';
import 'analytics/goals_and_targets.dart';
import '../../cubit/employee_analytics/employee_analytics_cubit.dart';

class AnalyticsSection extends StatefulWidget {
  final ThemeData theme;
  final CustomSpacing customSpacing;

  const AnalyticsSection({
    super.key,
    required this.theme,
    required this.customSpacing,
  });

  @override
  State<AnalyticsSection> createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _chartAnimation;
  late Animation<double> _cardAnimation;

  int _selectedMetricIndex = 0;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _chartAnimation = CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeOutCubic,
    );
    _cardAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOutBack,
    );

    _cardAnimationController.forward();
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeAnalyticsCubit()..loadAnalytics(),
      child: BlocBuilder<EmployeeAnalyticsCubit, EmployeeAnalyticsState>(
        builder: (context, state) {
          if (state is EmployeeAnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeAnalyticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<EmployeeAnalyticsCubit>().loadAnalytics(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(widget.customSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with time range selector
                AnalyticsHeader(customSpacing: widget.customSpacing),
                SizedBox(height: widget.customSpacing.lg),

                // Key metrics cards with improved layout (3x2 grid)
                AnimatedBuilder(
                  animation: _cardAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _cardAnimation.value,
                      child: MetricsGrid(
                        customSpacing: widget.customSpacing,
                        animation: _cardAnimation,
                      ),
                    );
                  },
                ),
                SizedBox(height: widget.customSpacing.lg),

                // Performance trends with interactive chart
                AnimatedBuilder(
                  animation: _chartAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _chartAnimation.value,
                      child: PerformanceTrendsChart(
                        theme: widget.theme,
                        customSpacing: widget.customSpacing,
                        chartAnimation: _chartAnimation,
                        selectedMetricIndex: _selectedMetricIndex,
                        onMetricChanged: (index) {
                          setState(() {
                            _selectedMetricIndex = index;
                          });
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: widget.customSpacing.lg),

                // Detailed analytics
                DetailedAnalytics(
                  theme: widget.theme,
                  customSpacing: widget.customSpacing,
                  cardAnimation: _cardAnimation,
                ),
                SizedBox(height: widget.customSpacing.lg),

                // Goals and targets
                GoalsAndTargets(
                  theme: widget.theme,
                  customSpacing: widget.customSpacing,
                  cardAnimation: _cardAnimation,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
