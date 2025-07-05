import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../employee/employee_widgets.dart';
import '../../../cubit/employee_analytics/employee_analytics_cubit.dart';

class AnalyticsHeader extends StatelessWidget {
  final CustomSpacing customSpacing;

  const AnalyticsHeader({super.key, required this.customSpacing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: EmployeeSectionHeader(title: 'Interaction Analytics')),
        BlocBuilder<EmployeeAnalyticsCubit, EmployeeAnalyticsState>(
          builder: (context, state) {
            final selectedTimeRange = state is EmployeeAnalyticsSuccess
                ? state.data.timeRange
                : 'This Week';

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: customSpacing.md,
                vertical: customSpacing.sm,
              ),
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTimeRange,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  items: ['Today', 'This Week', 'This Month', 'Last 3 Months']
                      .map(
                        (range) =>
                            DropdownMenuItem(value: range, child: Text(range)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<EmployeeAnalyticsCubit>().changeTimeRange(
                        value,
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
