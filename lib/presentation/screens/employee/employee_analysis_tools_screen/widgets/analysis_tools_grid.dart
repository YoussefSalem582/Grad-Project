import 'package:flutter/material.dart';
import '../../../../../core/core.dart';
import '../../../analysis/video_analysis_screen/video_analysis_screen.dart';
import 'analysis_tool_card.dart';

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
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analysis Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: customSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout based on screen width
            final screenWidth = constraints.maxWidth;
            final isTablet = screenWidth > 600;

            if (isTablet) {
              return _buildTabletLayout(customSpacing, context);
            } else {
              return _buildMobileLayout(customSpacing, context);
            }
          },
        ),
      ],
    );
  }

  /// Build tablet layout: 2 cards on top row, 1 centered on bottom
  Widget _buildTabletLayout(CustomSpacing customSpacing, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AnalysisToolCard(
                title: 'Text Analysis',
                description: 'Messages, emails & feedback',
                icon: Icons.text_fields,
                color: AppColors.secondary,
                onTap: () => onAnalysisToolTap(4), // Index 4 for text analysis
              ),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: AnalysisToolCard(
                title: 'Voice Analysis',
                description: 'Calls, recordings & audio',
                icon: Icons.mic,
                color: AppColors.success,
                onTap: () => onAnalysisToolTap(5), // Index 5 for voice analysis
              ),
            ),
          ],
        ),
        SizedBox(height: customSpacing.md),
        Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 2,
              child: AnalysisToolCard(
                title: 'Video Analysis',
                description: 'Customer videos & interviews',
                icon: Icons.video_library,
                color: const Color(0xFF667EEA),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmployeeVideoAnalysisScreen(),
                    ),
                  );
                },
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ],
    );
  }

  /// Build mobile layout: vertical stack
  Widget _buildMobileLayout(CustomSpacing customSpacing, BuildContext context) {
    return Column(
      children: [
        AnalysisToolCard(
          title: 'Text Analysis',
          description: 'Messages, emails & feedback',
          icon: Icons.text_fields,
          color: AppColors.secondary,
          onTap: () => onAnalysisToolTap(4), // Index 4 for text analysis
        ),
        SizedBox(height: customSpacing.md),
        AnalysisToolCard(
          title: 'Voice Analysis',
          description: 'Calls, recordings & audio',
          icon: Icons.mic,
          color: AppColors.success,
          onTap: () => onAnalysisToolTap(5), // Index 5 for voice analysis
        ),
        SizedBox(height: customSpacing.md),
        AnalysisToolCard(
          title: 'Video Analysis',
          description: 'Customer videos & interviews',
          icon: Icons.video_library,
          color: const Color(0xFF667EEA),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployeeVideoAnalysisScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
