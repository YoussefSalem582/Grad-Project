import 'package:flutter/material.dart';

/// Grid widget that displays all available analysis tools
///
/// Features:
/// - Responsive layout (tablet vs mobile)
/// - Consistent spacing and styling
/// - Navigation callbacks for each tool
class AnalysisToolsGrid extends StatelessWidget {
  /// Callback function to handle navigation to specific analysis tools
  /// The int parameter represents the screen index to navigate to
  final Function(int) onAnalysisToolTap;

  const AnalysisToolsGrid({super.key, required this.onAnalysisToolTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Tools',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
          children: [
            _buildAnalysisToolCard(
              context: context,
              title: 'Text Analysis',
              description: 'Analyze messages, emails, and feedback',
              icon: Icons.text_fields,
              color: Colors.blue,
              onTap: () => onAnalysisToolTap(0),
            ),
            _buildAnalysisToolCard(
              context: context,
              title: 'Voice Analysis',
              description: 'Analyze calls and audio content',
              icon: Icons.record_voice_over,
              color: Colors.green,
              onTap: () => onAnalysisToolTap(1),
            ),
            _buildAnalysisToolCard(
              context: context,
              title: 'Video Analysis',
              description: 'Analyze customer videos',
              icon: Icons.videocam,
              color: Colors.purple,
              onTap: () => onAnalysisToolTap(2),
            ),
            _buildAnalysisToolCard(
              context: context,
              title: 'Sentiment Trends',
              description: 'View emotional patterns',
              icon: Icons.trending_up,
              color: Colors.orange,
              onTap: () => onAnalysisToolTap(3),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnalysisToolCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
