import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class EmployeeAnalysisToolsScreen extends StatefulWidget {
  final Function(int)? onAnalysisToolSelected;

  const EmployeeAnalysisToolsScreen({super.key, this.onAnalysisToolSelected});

  @override
  State<EmployeeAnalysisToolsScreen> createState() =>
      _EmployeeAnalysisToolsScreenState();
}

class _EmployeeAnalysisToolsScreenState
    extends State<EmployeeAnalysisToolsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Animated Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6366F1), // Primary purple
                  Color(0xFF8B5CF6), // Secondary purple
                  Color(0xFF06B6D4), // Cyan at bottom
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                _buildCustomAppBar(customSpacing),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(customSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: customSpacing.md),

                        // Header Card
                        _buildHeaderCard(customSpacing),

                        SizedBox(height: customSpacing.xl),

                        // Section Title
                        const Text(
                          'Analysis Tools',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: customSpacing.md),

                        // Analysis Tools Cards
                        _buildAnalysisToolCard(
                          'Text Analysis',
                          'Messages, emails & feedback',
                          Icons.text_fields,
                          const Color(0xFF06B6D4),
                          customSpacing,
                          0,
                        ),

                        SizedBox(height: customSpacing.md),

                        _buildAnalysisToolCard(
                          'Voice Analysis',
                          'Calls, recordings & audio',
                          Icons.mic,
                          const Color(0xFF10B981),
                          customSpacing,
                          1,
                        ),

                        SizedBox(height: customSpacing.md),

                        _buildAnalysisToolCard(
                          'Video Analysis',
                          'Customer videos & interviews',
                          Icons.videocam,
                          const Color(0xFF6366F1),
                          customSpacing,
                          2,
                        ),

                        SizedBox(height: customSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analysis Tools',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: spacing.xs),
              const Text(
                'AI-powered insights & analytics',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          // Notification Icon
          Container(
            margin: EdgeInsets.only(right: spacing.sm),
            child: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(spacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Profile Icon
          Container(
            padding: EdgeInsets.all(spacing.sm),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.person_outline, color: Colors.white, size: 20),
                SizedBox(width: spacing.xs),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(CustomSpacing spacing) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),

          SizedBox(width: spacing.md),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis Tools',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: spacing.xs),
                const Text(
                  'AI-powered customer insights and analytics',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: spacing.sm),
                // Status indicator
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    const Text(
                      '3 tools available',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisToolCard(
    String title,
    String description,
    IconData icon,
    Color color,
    CustomSpacing spacing,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _handleAnalysisToolTap(index),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),

            SizedBox(width: spacing.md),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAnalysisToolTap(int screenIndex) {
    switch (screenIndex) {
      case 0: // Text Analysis
        AppRouter.toTextAnalysis(context);
        break;
      case 1: // Voice Analysis
        AppRouter.toVoiceAnalysis(context);
        break;
      case 2: // Video Analysis
        AppRouter.toVideoAnalysis(context);
        break;
      default:
        if (widget.onAnalysisToolSelected != null) {
          widget.onAnalysisToolSelected!(screenIndex);
        } else {
          _navigateToAnalysisFallback(screenIndex);
        }
    }
  }

  void _navigateToAnalysisFallback(int index) {
    try {
      Navigator.of(context).pop();
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(index);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unable to navigate to analysis tool'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    }
  }
}
