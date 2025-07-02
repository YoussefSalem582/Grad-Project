import 'package:flutter/material.dart';
import '../../../core/core.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final double opacity;
  final VoidCallback? onTap;
  final bool hasBorder;
  final bool hasShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.opacity = 0.15,
    this.onTap,
    this.hasBorder = true,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Stack(
        fit: (width == null && height == null)
            ? StackFit.loose
            : StackFit.expand,
        children: [
          // Glass background
          Container(
            width: (width == null && height == null) ? null : width,
            height: (width == null && height == null) ? null : height,
            constraints: (width == null && height == null)
                ? null
                : const BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: color ?? Colors.white.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: hasBorder
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : null,
              boxShadow: hasShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
          ),

          // Content
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                width: (width == null && height == null) ? null : width,
                height: (width == null && height == null) ? null : height,
                constraints: (width == null && height == null)
                    ? null
                    : const BoxConstraints.expand(),
                padding: padding ?? const EdgeInsets.all(20),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedGlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;
  final Duration animationDuration;

  const AnimatedGlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 0.1,
      end: 0.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GlassCard(
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              margin: widget.margin,
              borderRadius: widget.borderRadius,
              opacity: _opacityAnimation.value,
              onTap: widget.onTap,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Gradient gradient;
  final VoidCallback? onTap;
  final bool hasShadow;

  const GradientCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    required this.gradient,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customShadows = theme.extension<CustomShadows>()!;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow ? customShadows.medium : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

class ModernCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final bool hasShadow;
  final bool hasBorder;

  const ModernCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.onTap,
    this.hasShadow = true,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customShadows = theme.extension<CustomShadows>()!;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(color: AppColors.border, width: 1)
            : null,
        boxShadow: hasShadow ? customShadows.light : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
