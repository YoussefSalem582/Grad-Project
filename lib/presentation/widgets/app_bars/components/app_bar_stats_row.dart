import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.dart';
import '../app_bar.dart'; // For StatItem class

/// A horizontal row of statistics cards with staggered animations
class AppBarStatsRow extends StatelessWidget {
  /// List of statistics to display
  final List<StatItem> stats;

  /// Custom spacing configuration
  final CustomSpacing customSpacing;

  const AppBarStatsRow({
    super.key,
    required this.stats,
    required this.customSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children:
          stats.asMap().entries.map((entry) {
            final index = entry.key;
            final stat = entry.value;
            final isLast = index == stats.length - 1;

            return Expanded(
              child: Row(
                children: [
                  // Each stat takes equal space with staggered animation delay
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      duration: Duration(
                        milliseconds: 800 + (index * 150),
                      ), // Staggered timing
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutBack,
                      builder: (context, staggerValue, child) {
                        return Transform.translate(
                          offset: Offset(
                            0,
                            30 * (1 - staggerValue),
                          ), // Slide up effect
                          child: Opacity(
                            opacity: staggerValue,
                            child: AppBarStatCard(
                              stat: stat,
                              customSpacing: customSpacing,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Add spacing between stats (except after the last one)
                  if (!isLast) SizedBox(width: customSpacing.sm + 2),
                ],
              ),
            );
          }).toList(),
    );
  }
}

/// A single statistics card with animations and modern styling
class AppBarStatCard extends StatelessWidget {
  /// The statistic data to display
  final StatItem stat;

  /// Custom spacing configuration
  final CustomSpacing customSpacing;

  const AppBarStatCard({
    super.key,
    required this.stat,
    required this.customSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1200),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack, // Enhanced bounce effect
      builder: (context, animationValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animationValue), // Scale from 80% to 100%
          child: Semantics(
            label: '${stat.label}: ${stat.value}, ${stat.subtitle}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: EdgeInsets.all(customSpacing.md + 2),
                  decoration: BoxDecoration(
                    // Advanced glassmorphism background with multiple layers
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),

                    // Enhanced shadow system for depth
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(-3, -3),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 15,
                        offset: const Offset(4, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 25,
                        offset: const Offset(0, 8),
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Top row: Enhanced icon container and trending indicator
                      _buildTopRow(animationValue),
                      SizedBox(height: customSpacing.sm + 2),

                      // Main stat value with enhanced animation and typography
                      _buildStatValue(animationValue),
                      const SizedBox(height: 4),

                      // Bottom row: Enhanced label and subtitle with staggered animation
                      _buildBottomRow(animationValue),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopRow(double animationValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Enhanced colored icon container with gradient and shadows
        TweenAnimationBuilder<double>(
          duration: Duration(
            milliseconds: 600 + (animationValue * 200).toInt(),
          ),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutBack,
          builder: (context, iconValue, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * iconValue),
              child: Container(
                padding: EdgeInsets.all(customSpacing.xs + 2),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      stat.accentColor.withValues(alpha: 0.3),
                      stat.accentColor.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: stat.accentColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: stat.accentColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  stat.icon,
                  color: Colors.white,
                  size: 20,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Enhanced trending indicator with animation
        TweenAnimationBuilder<double>(
          duration: Duration(
            milliseconds: 800 + (animationValue * 300).toInt(),
          ),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, trendValue, child) {
            return Transform.rotate(
              angle: (1 - trendValue) * 0.5,
              child: Opacity(
                opacity: trendValue * 0.8,
                child: Icon(
                  Icons.trending_up,
                  color: stat.accentColor.withValues(alpha: 0.9),
                  size: 18,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      offset: const Offset(0.5, 0.5),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatValue(double animationValue) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1000 + (animationValue * 400).toInt()),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, valueAnimValue, child) {
        return Transform.translate(
          offset: Offset(20 * (1 - valueAnimValue), 0),
          child: Opacity(
            opacity: valueAnimValue,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                stat.value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900, // Extra bold for emphasis
                  letterSpacing: -0.8, // Tighter spacing for modern look
                  height: 1.1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      offset: const Offset(1.5, 1.5),
                      blurRadius: 3,
                    ),
                    Shadow(
                      color: stat.accentColor.withValues(alpha: 0.3),
                      offset: const Offset(-0.5, -0.5),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomRow(double animationValue) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 1200 + (animationValue * 500).toInt()),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, labelAnimValue, child) {
        return Transform.translate(
          offset: Offset(15 * (1 - labelAnimValue), 0),
          child: Opacity(
            opacity: labelAnimValue * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Enhanced stat label with better typography
                Flexible(
                  child: Text(
                    stat.label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0.5, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Enhanced stat subtitle with accent color and animation
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        stat.accentColor.withValues(alpha: 0.3),
                        stat.accentColor.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: stat.accentColor.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    stat.subtitle,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0.5, 0.5),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
