import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/common/animated_background_widget.dart';
import '../../widgets/employee_screen_widgets/analysis_tools_widgets/analysis_tools_header.dart';
import '../../widgets/employee_screen_widgets/analysis_tools_widgets/analysis_tools_grid.dart';

/// Employee Analysis Tools Screen
///
/// This screen provides access to various AI-powered analysis tools:
/// - Text Analysis: Analyze messages, emails, and feedback
/// - Voice Analysis: Analyze calls, recordings, and audio content
/// - Video Analysis: Analyze customer videos and interviews
///
/// Features:
/// - Responsive design for mobile and tablet
/// - Animated background effects
/// - Integration with parent navigation system
/// - Consistent theming and spacing
class EmployeeAnalysisToolsScreen extends StatefulWidget {
  /// Callback to navigate to specific analysis tool screens
  /// This allows communication with the parent navigation controller
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

                  // Header section
                  const AnalysisToolsHeader(),

                  SizedBox(height: customSpacing.xl),

                  // Analysis tools grid
                  AnalysisToolsGrid(onAnalysisToolTap: _handleAnalysisToolTap),

                  SizedBox(height: customSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Handle navigation to analysis tool screens
  /// This method communicates with the parent navigation system
  void _handleAnalysisToolTap(int screenIndex) {
    if (widget.onAnalysisToolSelected != null) {
      // If callback is provided, use it (preferred method)
      widget.onAnalysisToolSelected!(screenIndex);
    } else {
      // Fallback: Try to find parent navigation controller
      _navigateToAnalysisFallback(screenIndex);
    }
  }

  /// Fallback navigation method for backwards compatibility
  void _navigateToAnalysisFallback(int index) {
    // This method provides backwards compatibility but should be avoided
    // The preferred approach is to use the onAnalysisToolSelected callback
    try {
      Navigator.of(context).pop();
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(index);
      }
    } catch (e) {
      // If navigation fails, show a snackbar or handle gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to navigate to analysis tool'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    }
  }
}
