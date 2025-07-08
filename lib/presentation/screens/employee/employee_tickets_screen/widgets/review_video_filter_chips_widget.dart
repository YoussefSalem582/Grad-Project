import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

class ReviewVideoFilterChipsWidget extends StatelessWidget {
  final CustomSpacing spacing;
  final int selectedFilterIndex;
  final Function(int) onFilterChanged;
  final List<Map<String, dynamic>> tickets;

  const ReviewVideoFilterChipsWidget({
    super.key,
    required this.spacing,
    required this.selectedFilterIndex,
    required this.onFilterChanged,
    required this.tickets,
  });

  @override
  Widget build(BuildContext context) {
    final allCount = tickets.length;
    final openCount = tickets.where((t) => t['status'] == 'Open').length;
    final inProgressCount =
        tickets.where((t) => t['status'] == 'In Progress').length;
    final resolvedCount =
        tickets.where((t) => t['status'] == 'Resolved').length;

    final filters = [
      'All ($allCount)',
      'Open ($openCount)',
      'In Progress ($inProgressCount)',
      'Resolved ($resolvedCount)',
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing.md),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final isSelected = selectedFilterIndex == index;

          return GestureDetector(
            onTap: () => onFilterChanged(index),
            child: Container(
              margin: EdgeInsets.only(right: spacing.sm),
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.xs,
              ),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected
                          ? Colors.transparent
                          : Colors.white.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF6366F1) : Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
