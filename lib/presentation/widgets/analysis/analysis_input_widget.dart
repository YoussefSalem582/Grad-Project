import 'package:flutter/material.dart';
import '../../../core/core.dart';

class AnalysisInputWidget extends StatelessWidget {
  final String inputType;
  final Widget inputWidget;
  final VoidCallback? onAnalyze;
  final bool isAnalyzing;
  final String? analyzeButtonText;
  final List<String>? quickActions;
  final Function(String)? onQuickAction;

  const AnalysisInputWidget({
    super.key,
    required this.inputType,
    required this.inputWidget,
    this.onAnalyze,
    this.isAnalyzing = false,
    this.analyzeButtonText,
    this.quickActions,
    this.onQuickAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            inputType,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: customSpacing.md),
          inputWidget,
          if (quickActions != null && quickActions!.isNotEmpty) ...[
            SizedBox(height: customSpacing.md),
            _buildQuickActions(theme, customSpacing),
          ],
          SizedBox(height: customSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isAnalyzing ? null : onAnalyze,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: customSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: isAnalyzing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: customSpacing.sm),
                        const Text('Analyzing...'),
                      ],
                    )
                  : Text(
                      analyzeButtonText ?? 'Start Analysis',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme, CustomSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: spacing.sm),
        Wrap(
          spacing: spacing.xs,
          runSpacing: spacing.xs,
          children: quickActions!.map((action) {
            return ActionChip(
              label: Text(
                action,
                style: TextStyle(color: AppColors.primary, fontSize: 12),
              ),
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              onPressed: () => onQuickAction?.call(action),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
