import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A beautiful animated loading indicator with multiple animation effects
/// Perfect for analysis screens and long-running operations
class AnimatedLoadingIndicator extends StatefulWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final LoadingStyle style;
  final String? message;
  final TextStyle? messageStyle;

  const AnimatedLoadingIndicator({
    super.key,
    this.size = 80.0,
    this.primaryColor = const Color(0xFF667EEA),
    this.secondaryColor = const Color(0xFF764BA2),
    this.style = LoadingStyle.pulsing,
    this.message,
    this.messageStyle,
  });

  @override
  State<AnimatedLoadingIndicator> createState() =>
      _AnimatedLoadingIndicatorState();
}

class _AnimatedLoadingIndicatorState extends State<AnimatedLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late AnimationController _rotationController;

  late Animation<double> _primaryAnimation;
  late Animation<double> _secondaryAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Primary animation for main effect
    _primaryController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    // Secondary animation for overlay effects
    _secondaryController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Rotation animation
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _primaryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeInOut),
    );

    _secondaryAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _secondaryController, curve: Curves.elasticInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: _buildLoadingWidget(),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style:
                widget.messageStyle ??
                TextStyle(
                  color: widget.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingWidget() {
    switch (widget.style) {
      case LoadingStyle.pulsing:
        return _buildPulsingIndicator();
      case LoadingStyle.spinning:
        return _buildSpinningIndicator();
      case LoadingStyle.breathing:
        return _buildBreathingIndicator();
      case LoadingStyle.wave:
        return _buildWaveIndicator();
      case LoadingStyle.orbit:
        return _buildOrbitIndicator();
    }
  }

  Widget _buildPulsingIndicator() {
    return AnimatedBuilder(
      animation: Listenable.merge([_primaryAnimation, _secondaryAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing circle
            Container(
              width: widget.size * (0.8 + 0.2 * _primaryAnimation.value),
              height: widget.size * (0.8 + 0.2 * _primaryAnimation.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.primaryColor.withValues(
                      alpha: 0.3 - 0.2 * _primaryAnimation.value,
                    ),
                    widget.secondaryColor.withValues(
                      alpha: 0.1 - 0.1 * _primaryAnimation.value,
                    ),
                  ],
                ),
              ),
            ),
            // Inner pulsing circle
            Container(
              width: widget.size * (0.4 + 0.1 * _secondaryAnimation.value),
              height: widget.size * (0.4 + 0.1 * _secondaryAnimation.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.primaryColor.withValues(alpha: 0.8),
                    widget.secondaryColor.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpinningIndicator() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: SpinningPainter(
              primaryColor: widget.primaryColor,
              secondaryColor: widget.secondaryColor,
              progress: _primaryAnimation.value,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBreathingIndicator() {
    return AnimatedBuilder(
      animation: _primaryAnimation,
      builder: (context, child) {
        final breathingValue =
            (math.sin(_primaryAnimation.value * 2 * math.pi) + 1) / 2;
        return Transform.scale(
          scale: 0.7 + 0.3 * breathingValue,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  widget.primaryColor.withValues(
                    alpha: 0.8 + 0.2 * breathingValue,
                  ),
                  widget.secondaryColor.withValues(
                    alpha: 0.4 + 0.4 * breathingValue,
                  ),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWaveIndicator() {
    return AnimatedBuilder(
      animation: _primaryAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: WavePainter(
            primaryColor: widget.primaryColor,
            secondaryColor: widget.secondaryColor,
            progress: _primaryAnimation.value,
          ),
        );
      },
    );
  }

  Widget _buildOrbitIndicator() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationAnimation, _secondaryAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Central core
            Container(
              width: widget.size * 0.3,
              height: widget.size * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [widget.primaryColor, widget.secondaryColor],
                ),
              ),
            ),
            // Orbiting particles
            for (int i = 0; i < 3; i++)
              Transform.rotate(
                angle: _rotationAnimation.value + (i * 2 * math.pi / 3),
                child: Transform.translate(
                  offset: Offset(widget.size * 0.3, 0),
                  child: Container(
                    width: widget.size * 0.15,
                    height: widget.size * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryColor.withValues(alpha: 0.8),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Custom painter for spinning indicator
class SpinningPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double progress;

  SpinningPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..strokeCap = StrokeCap.round;

    // Draw gradient arc
    const sweepAngle = math.pi * 1.5;
    final startAngle = progress * 2 * math.pi;

    for (int i = 0; i < 20; i++) {
      final t = i / 19.0;
      paint.color = Color.lerp(primaryColor, secondaryColor, t)!;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 2),
        startAngle + (t * sweepAngle),
        sweepAngle / 20,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Custom painter for wave indicator
class WavePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double progress;

  WavePainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final waveProgress = (progress + i * 0.2) % 1.0;
      final radius = size.width * 0.1 * (1 + waveProgress * 3);
      final opacity = 1.0 - waveProgress;

      paint.color = Color.lerp(
        primaryColor,
        secondaryColor,
        i / 4.0,
      )!.withValues(alpha: opacity * 0.3);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Loading indicator styles
enum LoadingStyle { pulsing, spinning, breathing, wave, orbit }

/// Convenience widget for analysis loading
class AnalysisLoadingIndicator extends StatelessWidget {
  final String message;
  final LoadingStyle style;

  const AnalysisLoadingIndicator({
    super.key,
    this.message = 'Analyzing...',
    this.style = LoadingStyle.pulsing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedLoadingIndicator(
        size: 120,
        style: style,
        message: message,
        primaryColor: const Color(0xFF667EEA),
        secondaryColor: const Color(0xFF764BA2),
        messageStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
