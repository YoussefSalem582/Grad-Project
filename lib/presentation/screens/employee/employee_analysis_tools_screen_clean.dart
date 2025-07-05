import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/auth/animated_background_widget.dart';
import '../analysis/enhanced_text_analysis_screen.dart';
import '../analysis/enhanced_voice_analysis_screen.dart';
import '../analysis/enhanced_video_analysis_screen.dart';

class EmployeeAnalysisToolsScreen extends StatefulWidget {
  const EmployeeAnalysisToolsScreen({super.key});

  @override
  State<EmployeeAnalysisToolsScreen> createState() =>
      _EmployeeAnalysisToolsScreenState();
}

class _EmployeeAnalysisToolsScreenState
    extends State<EmployeeAnalysisToolsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _backgroundController.repeat(reverse: true);
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
          AnimatedBackgroundWidget(animation: _backgroundAnimation),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: customSpacing.md),
                  _buildHeader(theme, customSpacing),
                  SizedBox(height: customSpacing.xl),
                  _buildAnalysisToolsGrid(customSpacing),
                  SizedBox(height: customSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Tools',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  'AI-powered customer insights and analytics',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: customSpacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: customSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                      SizedBox(width: customSpacing.xs),
                      Text(
                        '3 tools available',
                        style: TextStyle(
                          color: AppColors.success,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisToolsGrid(CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: customSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive layout based on screen width
            final screenWidth = constraints.maxWidth;
            final isTablet = screenWidth > 600;

            if (isTablet) {
              // Tablet: 2 cards on top row, 1 centered on bottom
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildAnalysisToolCard(
                          'Text Analysis',
                          'Messages, emails & feedback',
                          Icons.text_fields,
                          AppColors.secondary,
                          () => _navigateToTextAnalysis(),
                        ),
                      ),
                      SizedBox(width: customSpacing.md),
                      Expanded(
                        child: _buildAnalysisToolCard(
                          'Voice Analysis',
                          'Calls, recordings & audio',
                          Icons.mic,
                          AppColors.success,
                          () => _navigateToVoiceAnalysis(),
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
                        child: _buildAnalysisToolCard(
                          'Video Analysis',
                          'Customer videos & interviews',
                          Icons.video_library,
                          const Color(0xFF667EEA),
                          () => _navigateToVideoAnalysis(),
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
                ],
              );
            } else {
              // Mobile: vertical stack with better proportions
              return Column(
                children: [
                  _buildAnalysisToolCard(
                    'Text Analysis',
                    'Messages, emails & feedback',
                    Icons.text_fields,
                    AppColors.secondary,
                    () => _navigateToTextAnalysis(),
                  ),
                  SizedBox(height: customSpacing.md),
                  _buildAnalysisToolCard(
                    'Voice Analysis',
                    'Calls, recordings & audio',
                    Icons.mic,
                    AppColors.success,
                    () => _navigateToVoiceAnalysis(),
                  ),
                  SizedBox(height: customSpacing.md),
                  _buildAnalysisToolCard(
                    'Video Analysis',
                    'Customer videos & interviews',
                    Icons.video_library,
                    const Color(0xFF667EEA),
                    () => _navigateToVideoAnalysis(),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildAnalysisToolCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140, // Fixed height for consistent look
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      color.withValues(alpha: 0.05),
                      color.withValues(alpha: 0.02),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: color.withValues(alpha: 0.6),
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTextAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedTextAnalysisScreen(),
      ),
    );
  }

  void _navigateToVoiceAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedVoiceAnalysisScreen(),
      ),
    );
  }

  void _navigateToVideoAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedVideoAnalysisScreen(),
      ),
    );
  }
}
