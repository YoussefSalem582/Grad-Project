import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/core.dart';
import '../../../widgets/navigation/employee_bottom_nav_bar.dart';
import 'widgets/employee_app_bar.dart';
import 'widgets/employee_screen_factory.dart';
import 'widgets/employee_dialogs.dart';

/// Enhanced Employee Navigation Screen with modular components
///
/// Features:
/// - Modular app bar with animations
/// - Lazy loading screens with caching
/// - Enhanced state management
/// - Consistent animations and feedback
/// - Improved performance and maintainability
class EmployeeNavigationScreen extends StatefulWidget {
  const EmployeeNavigationScreen({super.key});

  @override
  State<EmployeeNavigationScreen> createState() =>
      _EmployeeNavigationScreenState();
}

class _EmployeeNavigationScreenState extends State<EmployeeNavigationScreen>
    with TickerProviderStateMixin, ScreenStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _preloadEssentialScreens();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );

    // Start continuous animations
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  void _preloadEssentialScreens() {
    // Preload the most commonly used screens
    EmployeeScreenFactory.preloadScreens([0, 3, 4, 5]);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    EmployeeScreenFactory.clearCache(); // Clean up when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildWithState(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA).withValues(alpha: 0.1),
              const Color(0xFF764BA2).withValues(alpha: 0.1),
              const Color(0xFF48CAE4).withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: EmployeeAppBar(
            shimmerAnimation: _shimmerAnimation,
            pulseAnimation: _pulseAnimation,
            selectedIndex: _selectedIndex,
            onNotificationPressed:
                () => EmployeeDialogs.showNotifications(context),
            onProfilePressed: () => _handleProfileAction(),
            onProfileMenuSelected: _handleProfileMenuSelection,
          ),
          body: Stack(
            children: [
              IndexedStack(
                index: _selectedIndex,
                children: List.generate(9, (index) {
                  return EmployeeScreenFactory.getScreen(
                    index,
                    onAnalysisToolSelected: (toolIndex) {
                      _handleAnalysisToolSelection(toolIndex);
                    },
                  );
                }),
              ),
            ],
          ),
          bottomNavigationBar: EmployeeBottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _handleBottomNavTap,
          ),
        ),
      ),
      onRetry: _handleRetry,
    );
  }

  void _handleBottomNavTap(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Add haptic feedback
      HapticFeedback.lightImpact();

      // Reset animations when switching screens
      _pulseController.reset();
      _pulseController.forward();
    }
  }

  void _handleAnalysisToolSelection(int toolIndex) {
    // Handle navigation to specific analysis tools
    switch (toolIndex) {
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
        // For other tools, navigate within the app
        setState(() => _selectedIndex = toolIndex + 6);
    }
  }

  void _handleProfileAction() {
    setState(() => _selectedIndex = 3);
  }

  void _handleProfileMenuSelection(String value) {
    switch (value) {
      case 'profile':
        setState(() => _selectedIndex = 3);
        break;
      case 'help':
        EmployeeDialogs.showHelp(context);
        break;
      case 'settings':
        setState(() => _selectedIndex = 3);
        break;
      case 'logout':
        _handleLogout();
        break;
      case 'home':
        setState(() => _selectedIndex = 0);
        break;
    }
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.logout, color: AppColors.warning),
                const SizedBox(width: 8),
                const Text('Confirm Logout'),
              ],
            ),
            content: const Text(
              'Are you sure you want to logout? You will need to login again to access the app.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  AppRouter.toSplash(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  void _handleRetry() {
    setLoaded();
    _preloadEssentialScreens();
  }
}
