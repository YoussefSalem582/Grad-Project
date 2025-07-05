import 'package:flutter/material.dart';
import '../../../core/core.dart';

class EmployeeTabBar extends StatelessWidget {
  final List<String> titles;
  final List<IconData> icons;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const EmployeeTabBar({
    super.key,
    required this.titles,
    required this.icons,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.only(
        left: customSpacing.md,
        right: customSpacing.md,
        top: customSpacing.lg,
        bottom: customSpacing.md,
      ),
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
      child: Row(
        children: List.generate(titles.length, (index) {
          return _buildTab(titles[index], icons[index], index, customSpacing);
        }),
      ),
    );
  }

  Widget _buildTab(
    String title,
    IconData icon,
    int index,
    CustomSpacing customSpacing,
  ) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: customSpacing.md,
            horizontal: customSpacing.sm,
          ),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 18,
              ),
              SizedBox(width: customSpacing.xs),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
