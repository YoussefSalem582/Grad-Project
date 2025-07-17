import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../../core/routing/app_router.dart';
import '../../../core/utils/screen_state_manager.dart';
import '../../../core/di/dependency_injection.dart' as di;
import '../../cubit/admin_dashboard/admin_dashboard_cubit.dart';
import '../../cubit/tickets/tickets_cubit.dart';
import '../../widgets/navigation/admin_bottom_nav_bar.dart';
import 'widgets/admin_app_bar.dart';
import 'widgets/admin_dialogs.dart';
import 'admin_dashboard_screen.dart';
import 'admin_user_management_screen.dart';
import 'admin_system_config_screen.dart';
import 'admin_tickets_screen/admin_tickets_screen.dart';
import 'admin_profile_screen.dart';

/// Enhanced Admin Navigation Screen with modular components
///
/// Features:
/// - Modular app bar with admin-specific styling
/// - Enhanced state management with error handling
/// - Lazy loading with caching for better performance
/// - Admin-specific dialogs and notifications
/// - Consistent animations and feedback
/// - Improved maintainability and structure
class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen>
    with TickerProviderStateMixin, ScreenStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _backgroundController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;

  final Map<int, Widget?> _cachedScreens = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _preloadEssentialScreens();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );

    _pulseController.repeat(reverse: true);
    _backgroundController.repeat(reverse: true);
  }

  void _preloadEssentialScreens() {
    // Preload dashboard and profile screens
    _getScreen(0);
    _getScreen(4);
  }

  Widget _getScreen(int index) {
    // Check if screen is already cached
    if (_cachedScreens.containsKey(index) && _cachedScreens[index] != null) {
      return _cachedScreens[index]!;
    }

    // Build and cache the screen
    Widget screen;
    switch (index) {
      case 0:
        screen = BlocProvider(
          create: (context) => AdminDashboardCubit(),
          child: const AdminDashboardScreen(),
        );
        break;
      case 1:
        screen = const AdminUserManagementScreen();
        break;
      case 2:
        screen = BlocProvider(
          create: (context) => di.sl<TicketsCubit>(),
          child: const AdminTicketsScreen(),
        );
        break;
      case 3:
        screen = const AdminSystemConfigScreen();
        break;
      case 4:
        screen = const AdminProfileScreen();
        break;
      default:
        screen = const Center(
          child: Text(
            'Screen not found',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        );
    }

    _cachedScreens[index] = screen;
    return screen;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _backgroundController.dispose();
    _cachedScreens.clear(); // Clean up cached screens
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
              const Color(0xFF667EEA).withValues(alpha: 0.05),
              const Color(0xFF764BA2).withValues(alpha: 0.03),
              const Color(0xFF48CAE4).withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AdminAppBar(
            pulseAnimation: _pulseAnimation,
            selectedIndex: _selectedIndex,
            onNotificationPressed:
                () => AdminDialogs.showNotifications(context),
            onProfileMenuSelected: _handleProfileMenuSelection,
          ),
          body: Stack(
            children: [
              // Background floating elements
              _buildFloatingBackground(),

              // Main content
              IndexedStack(
                index: _selectedIndex,
                children: List.generate(5, (index) => _getScreen(index)),
              ),

              // Admin badge overlay with system status indicator
              Positioned(
                top: 16,
                right: 16,
                child: _buildSystemStatusIndicator(),
              ),
            ],
          ),
          bottomNavigationBar: AdminBottomNavBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _handleBottomNavTap,
          ),
        ),
      ),
      onRetry: _handleRetry,
    );
  }

  Widget _buildFloatingBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Floating elements with admin theme
            Positioned(
              top: 100 + (50 * _backgroundAnimation.value),
              left: 50 + (30 * _backgroundAnimation.value),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 200 + (40 * _backgroundAnimation.value),
              right: 80 + (20 * _backgroundAnimation.value),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF667EEA).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSystemStatusIndicator() {
    return GestureDetector(
      onTap: () => AdminDialogs.showSystemStatus(context),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.9 + (0.1 * _pulseAnimation.value),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'ONLINE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  void _handleProfileMenuSelection(String value) {
    switch (value) {
      case 'profile':
        setState(() => _selectedIndex = 4);
        break;
      case 'settings':
        setState(() => _selectedIndex = 3);
        break;
      case 'help':
        AdminDialogs.showHelp(context);
        break;
      case 'logout':
        _handleLogout();
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
                Icon(Icons.admin_panel_settings, color: AppColors.warning),
                const SizedBox(width: 8),
                const Text('Admin Logout'),
              ],
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to logout from the admin panel?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Text(
                  'This will end your administrative session and require re-authentication.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
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
