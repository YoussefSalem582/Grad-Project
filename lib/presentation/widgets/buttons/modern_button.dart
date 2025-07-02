import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../common/loading_widgets.dart';

enum ModernButtonStyle { primary, secondary, outlined, text }

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonStyle style;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = ModernButtonStyle.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height = 48,
    this.width,
    this.padding,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle(context);
    final textStyle = _getTextStyle(context);
    final loadingColor = _getLoadingColor();

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null && !isLoading) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: LoadingSpinner(size: 20, color: loadingColor),
          ),
          const SizedBox(width: 8),
        ],
        Text(text, style: textStyle),
      ],
    );

    if (isFullWidth) {
      buttonChild = Center(child: buttonChild);
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            decoration: buttonStyle,
            padding:
                padding ??
                EdgeInsets.symmetric(
                  horizontal: isFullWidth ? 24 : 16,
                  vertical: 0,
                ),
            child: buttonChild,
          ),
        ),
      ),
    );
  }

  BoxDecoration _getButtonStyle(BuildContext context) {
    switch (style) {
      case ModernButtonStyle.primary:
        return BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case ModernButtonStyle.secondary:
        return BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case ModernButtonStyle.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case ModernButtonStyle.text:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    const baseStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

    switch (style) {
      case ModernButtonStyle.primary:
        return baseStyle.copyWith(color: Colors.white);
      case ModernButtonStyle.secondary:
        return baseStyle.copyWith(color: Colors.white);
      case ModernButtonStyle.outlined:
        return baseStyle.copyWith(color: AppColors.primary);
      case ModernButtonStyle.text:
        return baseStyle.copyWith(color: AppColors.primary);
    }
  }

  Color _getLoadingColor() {
    switch (style) {
      case ModernButtonStyle.primary:
      case ModernButtonStyle.secondary:
        return Colors.white;
      case ModernButtonStyle.outlined:
      case ModernButtonStyle.text:
        return AppColors.primary;
    }
  }
}

class IconButtonWithBadge extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? badgeText;
  final Color? badgeColor;
  final Color? iconColor;
  final double size;

  const IconButtonWithBadge({
    super.key,
    required this.icon,
    required this.onPressed,
    this.badgeText,
    this.badgeColor,
    this.iconColor,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: iconColor, size: size),
          onPressed: onPressed,
        ),
        if (badgeText != null)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
