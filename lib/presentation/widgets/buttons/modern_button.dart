import 'package:flutter/material.dart';
import '../../../core/core.dart';

enum ModernButtonStyle {
  primary,
  secondary,
  accent,
  outlined,
  ghost,
  danger,
  success,
}

enum ModernButtonSize { small, medium, large }

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonStyle style;
  final ModernButtonSize size;
  final IconData? icon;
  final bool iconOnRight;
  final bool isLoading;
  final bool isFullWidth;
  final double? borderRadius;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = ModernButtonStyle.primary,
    this.size = ModernButtonSize.medium,
    this.icon,
    this.iconOnRight = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderRadius,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonConfig = _getButtonConfig();
    final sizeConfig = _getSizeConfig();

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.isFullWidth ? double.infinity : null,
              height: sizeConfig.height,
              decoration: BoxDecoration(
                gradient: buttonConfig.gradient,
                color: buttonConfig.backgroundColor,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? sizeConfig.borderRadius,
                ),
                border: buttonConfig.border,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? sizeConfig.borderRadius,
                  ),
                  child: Container(
                    padding: sizeConfig.padding,
                    child: _buildContent(buttonConfig, sizeConfig),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(ButtonConfig config, SizeConfig sizeConfig) {
    final children = <Widget>[];

    if (widget.isLoading) {
      children.add(
        SizedBox(
          width: sizeConfig.iconSize,
          height: sizeConfig.iconSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(config.textColor),
          ),
        ),
      );
    } else {
      if (widget.icon != null && !widget.iconOnRight) {
        children.add(
          Icon(widget.icon, size: sizeConfig.iconSize, color: config.textColor),
        );
        children.add(SizedBox(width: sizeConfig.spacing));
      }

      children.add(
        Text(
          widget.text,
          style: TextStyle(
            fontSize: sizeConfig.fontSize,
            fontWeight: FontWeight.w600,
            color: config.textColor,
            fontFamily: 'Inter',
          ),
        ),
      );

      if (widget.icon != null && widget.iconOnRight) {
        children.add(SizedBox(width: sizeConfig.spacing));
        children.add(
          Icon(widget.icon, size: sizeConfig.iconSize, color: config.textColor),
        );
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  ButtonConfig _getButtonConfig() {
    switch (widget.style) {
      case ModernButtonStyle.primary:
        return ButtonConfig(
          backgroundColor: AppColors.primary,
          gradient: null,
          textColor: Colors.white,
          border: null,
        );
      case ModernButtonStyle.secondary:
        return ButtonConfig(
          backgroundColor: AppColors.secondary,
          gradient: null,
          textColor: Colors.white,
          border: null,
        );
      case ModernButtonStyle.accent:
        return ButtonConfig(
          backgroundColor: AppColors.accent,
          gradient: null,
          textColor: Colors.white,
          border: null,
        );
      case ModernButtonStyle.outlined:
        return ButtonConfig(
          backgroundColor: Colors.transparent,
          gradient: null,
          textColor: AppColors.primary,
          border: Border.all(color: AppColors.primary, width: 1.5),
        );
      case ModernButtonStyle.ghost:
        return ButtonConfig(
          backgroundColor: AppColors.primarySurface,
          gradient: null,
          textColor: AppColors.primary,
          border: null,
        );
      case ModernButtonStyle.danger:
        return ButtonConfig(
          backgroundColor: AppColors.error,
          gradient: null,
          textColor: Colors.white,
          border: null,
        );
      case ModernButtonStyle.success:
        return ButtonConfig(
          backgroundColor: AppColors.success,
          gradient: null,
          textColor: Colors.white,
          border: null,
        );
    }
  }

  SizeConfig _getSizeConfig() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return SizeConfig(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          fontSize: 13,
          iconSize: 16,
          borderRadius: 8,
          spacing: 6,
        );
      case ModernButtonSize.medium:
        return SizeConfig(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          fontSize: 14,
          iconSize: 18,
          borderRadius: 10,
          spacing: 8,
        );
      case ModernButtonSize.large:
        return SizeConfig(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 16,
          iconSize: 20,
          borderRadius: 12,
          spacing: 10,
        );
    }
  }
}

class ButtonConfig {
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final Border? border;

  ButtonConfig({
    this.backgroundColor,
    this.gradient,
    required this.textColor,
    this.border,
  });
}

class SizeConfig {
  final double height;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;
  final double spacing;

  SizeConfig({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
    required this.spacing,
  });
}

class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool iconOnRight;
  final ModernButtonSize size;
  final bool isFullWidth;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.iconOnRight = false,
    this.size = ModernButtonSize.medium,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final sizeConfig = _getSizeConfig();

    return Container(
      width: isFullWidth ? double.infinity : null,
      height: sizeConfig.height,
      decoration: BoxDecoration(
        color: AppColors.glass.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
        border: Border.all(color: AppColors.glassLight, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(sizeConfig.borderRadius),
          child: Container(
            padding: sizeConfig.padding,
            child: _buildContent(sizeConfig),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(SizeConfig sizeConfig) {
    final children = <Widget>[];

    if (icon != null && !iconOnRight) {
      children.add(
        Icon(icon, size: sizeConfig.iconSize, color: AppColors.textPrimary),
      );
      children.add(SizedBox(width: sizeConfig.spacing));
    }

    children.add(
      Text(
        text,
        style: TextStyle(
          fontSize: sizeConfig.fontSize,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Inter',
        ),
      ),
    );

    if (icon != null && iconOnRight) {
      children.add(SizedBox(width: sizeConfig.spacing));
      children.add(
        Icon(icon, size: sizeConfig.iconSize, color: AppColors.textPrimary),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  SizeConfig _getSizeConfig() {
    switch (size) {
      case ModernButtonSize.small:
        return SizeConfig(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          fontSize: 13,
          iconSize: 16,
          borderRadius: 8,
          spacing: 6,
        );
      case ModernButtonSize.medium:
        return SizeConfig(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          fontSize: 14,
          iconSize: 18,
          borderRadius: 10,
          spacing: 8,
        );
      case ModernButtonSize.large:
        return SizeConfig(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 16,
          iconSize: 20,
          borderRadius: 12,
          spacing: 10,
        );
    }
  }
}
