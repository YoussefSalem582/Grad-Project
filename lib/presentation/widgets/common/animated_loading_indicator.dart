import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Animation styles for EMO letters
enum EmoAnimationStyle { bounce, wave, pulse, rotate, fade }

/// Simple EMO loading indicator with letter animations
class EmoLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final EmoAnimationStyle animationStyle;
  final Duration duration;

  const EmoLoadingIndicator({
    super.key,
    this.size = 80.0,
    this.color,
    this.animationStyle = EmoAnimationStyle.bounce,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<EmoLoadingIndicator> createState() => _EmoLoadingIndicatorState();
}

class _EmoLoadingIndicatorState extends State<EmoLoadingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(3, (index) {
      return AnimationController(duration: widget.duration, vsync: this);
    });

    _animations =
        _controllers.map((controller) {
          switch (widget.animationStyle) {
            case EmoAnimationStyle.bounce:
              return Tween<double>(begin: 0.0, end: -20.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.elasticOut),
              );
            case EmoAnimationStyle.wave:
              return Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              );
            case EmoAnimationStyle.pulse:
              return Tween<double>(begin: 1.0, end: 1.3).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              );
            case EmoAnimationStyle.rotate:
              return Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              );
            case EmoAnimationStyle.fade:
              return Tween<double>(begin: 0.3, end: 1.0).animate(
                CurvedAnimation(parent: controller, curve: Curves.easeInOut),
              );
          }
        }).toList();

    _startAnimations();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildLetter(String letter, int index) {
    final animation = _animations[index];
    final color = widget.color ?? AppColors.primary;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        switch (widget.animationStyle) {
          case EmoAnimationStyle.bounce:
            return Transform.translate(
              offset: Offset(0, animation.value),
              child: _buildLetterWidget(letter, color),
            );
          case EmoAnimationStyle.wave:
            return Transform.translate(
              offset: Offset(0, -15 * animation.value),
              child: _buildLetterWidget(letter, color),
            );
          case EmoAnimationStyle.pulse:
            return Transform.scale(
              scale: animation.value,
              child: _buildLetterWidget(letter, color),
            );
          case EmoAnimationStyle.rotate:
            return Transform.rotate(
              angle: animation.value * 6.28, // 2π radians
              child: _buildLetterWidget(letter, color),
            );
          case EmoAnimationStyle.fade:
            return Opacity(
              opacity: animation.value,
              child: _buildLetterWidget(letter, color),
            );
        }
      },
    );
  }

  Widget _buildLetterWidget(String letter, Color color) {
    return Text(
      letter,
      style: TextStyle(
        fontSize: widget.size * 0.6,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLetter('E', 0),
          _buildLetter('M', 1),
          _buildLetter('O', 2),
        ],
      ),
    );
  }
}

/// Helper class for easy EMO loading indicator usage
class EmoLoader {
  /// Default EMO loader with bounce animation
  static Widget standard({
    double size = 80.0,
    Color? color,
    Duration duration = const Duration(milliseconds: 1200),
  }) {
    return EmoLoadingIndicator(
      size: size,
      color: color,
      animationStyle: EmoAnimationStyle.bounce,
      duration: duration,
    );
  }

  /// EMO loader for analysis screens
  static Widget analysis({double size = 60.0, Color? color}) {
    return EmoLoadingIndicator(
      size: size,
      color: color ?? Colors.white,
      animationStyle: EmoAnimationStyle.wave,
      duration: const Duration(milliseconds: 1000),
    );
  }

  /// EMO loader for small spaces
  static Widget mini({double size = 40.0, Color? color}) {
    return EmoLoadingIndicator(
      size: size,
      color: color ?? AppColors.secondary,
      animationStyle: EmoAnimationStyle.pulse,
      duration: const Duration(milliseconds: 800),
    );
  }

  /// EMO loader with fade animation
  static Widget fade({double size = 80.0, Color? color}) {
    return EmoLoadingIndicator(
      size: size,
      color: color ?? AppColors.accent,
      animationStyle: EmoAnimationStyle.fade,
      duration: const Duration(milliseconds: 1500),
    );
  }

  /// EMO loader with rotation animation
  static Widget rotate({double size = 80.0, Color? color}) {
    return EmoLoadingIndicator(
      size: size,
      color: color ?? AppColors.primary,
      animationStyle: EmoAnimationStyle.rotate,
      duration: const Duration(milliseconds: 2000),
    );
  }
}

// Legacy compatibility classes to maintain backward compatibility
class EmosenseAnalysisLoadingIndicator extends StatelessWidget {
  final EmosenseLoadingStyle style;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double size;

  const EmosenseAnalysisLoadingIndicator({
    super.key,
    this.style = EmosenseLoadingStyle.brainWave,
    this.primaryColor,
    this.secondaryColor,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return EmoLoader.analysis(size: size, color: primaryColor);
  }
}

enum EmosenseLoadingStyle {
  brainWave,
  neuralNetwork,
  emotionOrbit,
  textPulse,
  voicePulse,
}

class EmosenseLoadingIndicator extends StatelessWidget {
  final EmosenseLoadingStyle style;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double size;

  const EmosenseLoadingIndicator({
    super.key,
    this.style = EmosenseLoadingStyle.brainWave,
    this.primaryColor,
    this.secondaryColor,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return EmoLoader.standard(size: size, color: primaryColor);
  }
}

class EmosenseTextAnalysisLoadingIndicator extends StatelessWidget {
  final Color? primaryColor;
  final double size;

  const EmosenseTextAnalysisLoadingIndicator({
    super.key,
    this.primaryColor,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return EmoLoader.analysis(size: size, color: primaryColor);
  }
}

class EmosenseVoiceAnalysisLoadingIndicator extends StatelessWidget {
  final Color? primaryColor;
  final double size;

  const EmosenseVoiceAnalysisLoadingIndicator({
    super.key,
    this.primaryColor,
    this.size = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return EmoLoader.analysis(size: size, color: primaryColor);
  }
}
