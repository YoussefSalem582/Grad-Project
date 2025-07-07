import 'package:flutter/material.dart';
import 'analysis.dart';

/// Header widget for the Enhanced Text Analysis screen
///
/// Displays the main title, description, and quick statistics
/// with an attractive gradient background and icon.
class EnhancedTextAnalysisHeaderWidget extends StatelessWidget {
  const EnhancedTextAnalysisHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const quickStats = [
      AnalysisHeaderStat(value: '47', label: 'Analyzed', icon: Icons.analytics),
      AnalysisHeaderStat(value: '94%', label: 'Accuracy', icon: Icons.verified),
      AnalysisHeaderStat(value: '1.2s', label: 'Speed', icon: Icons.speed),
    ];

    return AnalysisHeaderWidget(
      title: 'AI Text Analysis',
      description: 'Advanced NLP powered by machine learning',
      icon: Icons.auto_awesome,
      gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
      stats: quickStats,
    );
  }
}
