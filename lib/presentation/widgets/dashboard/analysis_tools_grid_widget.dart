import 'package:flutter/material.dart';
import '../../../core/core.dart';

class AnalysisToolsGridWidget extends StatelessWidget {
  final VoidCallback onTextAnalysisTap;
  final VoidCallback onVoiceAnalysisTap;
  final VoidCallback onVideoAnalysisTap;
  final VoidCallback onAllToolsTap;

  const AnalysisToolsGridWidget({
    super.key,
    required this.onTextAnalysisTap,
    required this.onVoiceAnalysisTap,
    required this.onVideoAnalysisTap,
    required this.onAllToolsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    final tools = [
      {
        'title': 'Text Analysis',
        'description': 'Analyze customer messages',
        'icon': Icons.text_fields,
        'color': const Color(0xFF4285F4),
        'onTap': onTextAnalysisTap,
      },
      {
        'title': 'Voice Analysis',
        'description': 'Process voice interactions',
        'icon': Icons.mic,
        'color': const Color(0xFF34A853),
        'onTap': onVoiceAnalysisTap,
      },
      {
        'title': 'Video Analysis',
        'description': 'Analyze video calls',
        'icon': Icons.videocam,
        'color': const Color(0xFFEA4335),
        'onTap': onVideoAnalysisTap,
      },
      {
        'title': 'All Tools',
        'description': 'View complete toolkit',
        'icon': Icons.build_circle,
        'color': const Color(0xFFFBBC05),
        'onTap': onAllToolsTap,
      },
    ];

    return Container(
      margin: EdgeInsets.all(customSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analysis Tools',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: customSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return _AnalysisToolCard(
                title: tool['title'] as String,
                description: tool['description'] as String,
                icon: tool['icon'] as IconData,
                color: tool['color'] as Color,
                onTap: tool['onTap'] as VoidCallback,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AnalysisToolCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AnalysisToolCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.1),
                    color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
