import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/auth/animated_background_widget.dart';

/// Base class for all analysis screens providing consistent UI structure
abstract class BaseAnalysisScreen extends StatefulWidget {
  const BaseAnalysisScreen({super.key});
}

abstract class BaseAnalysisScreenState<T extends BaseAnalysisScreen>
    extends State<T>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;

  /// Override to provide the analysis type name
  String get analysisType;

  /// Override to provide the analysis type icon
  IconData get analysisIcon;

  /// Override to provide the analysis type description
  String get analysisDescription;

  /// Override to provide the gradient colors for the header
  List<Color> get gradientColors;

  /// Override to provide analysis stats
  List<Map<String, dynamic>> get headerStats;

  /// Override to build the main analysis content
  Widget buildAnalysisContent(
    BuildContext context,
    ThemeData theme,
    CustomSpacing spacing,
  );

  /// Override to build additional features section
  Widget? buildAdditionalFeatures(
    BuildContext context,
    ThemeData theme,
    CustomSpacing spacing,
  ) => null;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    );

    _fadeController.forward();
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackgroundWidget(animation: _backgroundAnimation),

          // Main Content
          FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: Column(
                children: [
                  // Modern App Bar
                  _buildModernAppBar(context, theme, customSpacing),

                  // Scrollable Content
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(customSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Enhanced Header Card
                            _buildEnhancedHeader(theme, customSpacing),
                            SizedBox(height: customSpacing.lg),

                            // Main Analysis Content
                            buildAnalysisContent(context, theme, customSpacing),

                            // Additional Features (if provided)
                            if (buildAdditionalFeatures(
                                  context,
                                  theme,
                                  customSpacing,
                                ) !=
                                null) ...[
                              SizedBox(height: customSpacing.lg),
                              buildAdditionalFeatures(
                                context,
                                theme,
                                customSpacing,
                              )!,
                            ],

                            // Bottom Padding
                            SizedBox(height: customSpacing.xxl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAppBar(
    BuildContext context,
    ThemeData theme,
    CustomSpacing spacing,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.sm,
        spacing.md,
        spacing.md,
      ),
      child: Row(
        children: [
          // Back Button
          _buildGlassButton(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.of(context).pop(),
            spacing: spacing,
          ),

          SizedBox(width: spacing.md),

          // Title
          Expanded(
            child: Text(
              '$analysisType Studio',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Settings Button
          _buildGlassButton(
            icon: Icons.settings,
            onTap: () => _showSettings(context),
            spacing: spacing,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    required CustomSpacing spacing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacing.sm),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.2),
              Colors.white.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildEnhancedHeader(ThemeData theme, CustomSpacing spacing) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: EdgeInsets.all(spacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors.first.withValues(alpha: 0.3),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 20),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Content
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(spacing.md),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          analysisIcon,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),

                      SizedBox(width: spacing.md),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              analysisType,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: spacing.xs),
                            Text(
                              analysisDescription,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: spacing.lg),

                  // Stats Row
                  Row(
                    children: headerStats.map((stat) {
                      return Expanded(
                        child: _buildHeaderStat(
                          stat['label'] as String,
                          stat['value'] as String,
                          stat['icon'] as IconData,
                          spacing,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderStat(
    String label,
    String value,
    IconData icon,
    CustomSpacing spacing,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spacing.xs),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          SizedBox(height: spacing.xs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.xs / 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Override in subclasses for specific refresh logic
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showSettings(BuildContext context) {
    // Override in subclasses for specific settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$analysisType Settings'),
        content: const Text('Settings coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
