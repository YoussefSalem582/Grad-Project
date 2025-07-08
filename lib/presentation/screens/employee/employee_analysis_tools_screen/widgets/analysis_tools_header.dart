import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

/// Header widget for the analysis tools screen
///
/// Displays:
/// - Analysis tools title and description
/// - Status indicator showing available tools count
/// - Consistent styling with gradient background
class AnalysisToolsHeader extends StatelessWidget {
  const AnalysisToolsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon container with gradient
          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),
          SizedBox(width: customSpacing.md),
          SizedBox(height: customSpacing.sm),

          // Status indicator
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: customSpacing.sm,
              vertical: customSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 16),
                SizedBox(width: customSpacing.xs),
                Text(
                  '3 tools available',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
