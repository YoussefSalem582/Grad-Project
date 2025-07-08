import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// A reusable loading screen with animated indicators
class LoadingScreen extends StatefulWidget {
  final String message;
  final bool showProgress;
  final double? progress;
  final VoidCallback? onCancel;
  final Color? backgroundColor;
  final bool isFullScreen;

  const LoadingScreen({
    super.key,
    this.message = 'Loading...',
    this.showProgress = false,
    this.progress,
    this.onCancel,
    this.backgroundColor,
    this.isFullScreen = true,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildLoadingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Enhanced loading indicator
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.accent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),

        const SizedBox(height: 24),

        // Loading message
        Text(
          widget.message,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Progress bar (if needed)
        if (widget.showProgress) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: widget.progress,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          if (widget.progress != null) ...[
            const SizedBox(height: 8),
            Text(
              '${(widget.progress! * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],

        const SizedBox(height: 24),

        // Cancel button (if provided)
        if (widget.onCancel != null) ...[
          TextButton(
            onPressed: widget.onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFullScreen) {
      return Scaffold(
        backgroundColor: widget.backgroundColor ?? AppColors.background,
        body: SafeArea(
          child: Center(
            child: _buildLoadingContent(),
          ),
        ),
      );
    } else {
      return Container(
        color: widget.backgroundColor ?? AppColors.background.withValues(alpha: 0.9),
        child: Center(
          child: _buildLoadingContent(),
        ),
      );
    }
  }
}
