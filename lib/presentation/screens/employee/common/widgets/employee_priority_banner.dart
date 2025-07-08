import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../../../../widgets/widgets.dart';

class EmployeePriorityBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color primaryColor;
  final Color? secondaryColor;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmployeePriorityBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.primaryColor,
    this.secondaryColor,
    this.onActionPressed,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final customSpacing = Theme.of(context).extension<CustomSpacing>()!;

    return Container(
      padding: EdgeInsets.all(customSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withValues(alpha: 0.05),
            (secondaryColor ?? primaryColor).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.sm),
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          SizedBox(width: customSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
          if (onActionPressed != null && actionText != null)
            ModernButton(
              onPressed: onActionPressed!,
              style: ModernButtonStyle.outlined,
              text: actionText!,
              size: ModernButtonSize.small,
            ),
        ],
      ),
    );
  }
}
