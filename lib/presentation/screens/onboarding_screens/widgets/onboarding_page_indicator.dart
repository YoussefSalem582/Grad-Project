import 'package:flutter/material.dart';

/// Page indicator widget showing current page progress
class OnboardingPageIndicator extends StatefulWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;

  const OnboardingPageIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  State<OnboardingPageIndicator> createState() =>
      _OnboardingPageIndicatorState();
}

class _OnboardingPageIndicatorState extends State<OnboardingPageIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.totalPages,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    _animations =
        _controllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    // Animate current page indicator
    _controllers[widget.currentPage].forward();
  }

  @override
  void didUpdateWidget(OnboardingPageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPage != oldWidget.currentPage) {
      // Reset previous page animation
      if (oldWidget.currentPage < _controllers.length) {
        _controllers[oldWidget.currentPage].reverse();
      }
      // Start current page animation
      if (widget.currentPage < _controllers.length) {
        _controllers[widget.currentPage].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.totalPages, (index) {
        final isActive = index == widget.currentPage;

        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: isActive ? 24.0 : 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color:
                      isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                  boxShadow:
                      isActive
                          ? [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child:
                    isActive
                        ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.white,
                                Colors.white.withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        )
                        : null,
              ),
            );
          },
        );
      }),
    );
  }
}

/// Alternative dot-style page indicator
class OnboardingDotIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;

  const OnboardingDotIndicator({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.dotSize = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isActive ? dotSize * 1.5 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : inactiveColor.withOpacity(0.4),
            boxShadow:
                isActive
                    ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : null,
          ),
        );
      }),
    );
  }
}
