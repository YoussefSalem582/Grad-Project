import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class EmployeeFilterChips extends StatelessWidget {
  final List<String> labels;
  final List<int> counts;
  final int selectedIndex;
  final ValueChanged<int> onSelectionChanged;

  const EmployeeFilterChips({
    super.key,
    required this.labels,
    required this.counts,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = selectedIndex == index;
          return Container(
            margin: EdgeInsets.only(right: customSpacing.sm),
            child: FilterChip(
              label: Text('${labels[index]} (${counts[index]})'),
              selected: isSelected,
              onSelected: (selected) => onSelectionChanged(index),
              selectedColor: AppColors.primary.withValues(alpha: 0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        }),
      ),
    );
  }
}
