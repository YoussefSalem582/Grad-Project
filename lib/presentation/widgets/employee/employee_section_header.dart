import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../widgets.dart';

class EmployeeSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final Widget? action;
  final VoidCallback? onActionPressed;
  final String? actionText;
  final IconData? actionIcon;
  final ModernButtonStyle? actionStyle;

  const EmployeeSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.action,
    this.onActionPressed,
    this.actionText,
    this.actionIcon,
    this.actionStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: customSpacing.xs),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (badgeText != null) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.sm,
                  vertical: customSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: (badgeColor ?? AppColors.primary).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    color: badgeColor ?? AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: customSpacing.sm),
            ],
            if (action != null) action!,
            if (action == null && onActionPressed != null && actionText != null)
              ModernButton(
                onPressed: onActionPressed!,
                style: actionStyle ?? ModernButtonStyle.primary,
                text: actionText!,
                icon: actionIcon,
                size: ModernButtonSize.small,
              ),
          ],
        ),
        SizedBox(height: customSpacing.lg),
      ],
    );
  }
}
