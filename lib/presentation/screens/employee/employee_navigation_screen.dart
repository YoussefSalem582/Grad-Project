import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import '../../cubit/employee_dashboard/employee_dashboard_cubit.dart';
import '../../cubit/employee_performance/employee_performance_cubit.dart';
import 'employee_dashboard_screen.dart';
import 'employee_customer_interactions_screen.dart';
import 'employee_performance_screen.dart';
import 'employee_profile_screen.dart';
import 'employee_analysis_tools_screen.dart';

import '../analysis/enhanced_text_analysis_screen.dart';
import '../analysis/enhanced_voice_analysis_screen.dart';
import '../analysis/enhanced_video_analysis_screen.dart';

class EmployeeNavigationScreen extends StatefulWidget {
  const EmployeeNavigationScreen({super.key});

  @override
  State<EmployeeNavigationScreen> createState() =>
      _EmployeeNavigationScreenState();
}

class _EmployeeNavigationScreenState extends State<EmployeeNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  final List<Widget> _screens = [
    BlocProvider(
      create: (context) => EmployeeDashboardCubit(),
      child: const EmployeeDashboardScreen(),
    ),
    const EmployeeCustomerInteractionsScreen(),
    BlocProvider(
      create: (context) => EmployeePerformanceCubit(),
      child: const EmployeePerformanceScreen(),
    ),
    const EmployeeProfileScreen(),
    const EmployeeAnalysisToolsScreen(),
    const EnhancedTextAnalysisScreen(),
    const EnhancedVoiceAnalysisScreen(),
    const EnhancedVideoAnalysisScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Container(
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
        appBar: _buildEnhancedAppBar(theme, customSpacing),
        body: Stack(
          children: [IndexedStack(index: _selectedIndex, children: _screens)],
        ),
        bottomNavigationBar: _buildModernNavBar(),
      ),
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar(
    ThemeData theme,
    CustomSpacing customSpacing,
  ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 95,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA).withValues(alpha: 0.25),
              const Color(0xFF764BA2).withValues(alpha: 0.2),
              const Color(0xFF48CAE4).withValues(alpha: 0.15),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Animated shimmer effect
            AnimatedBuilder(
              animation: _shimmerAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF667EEA).withValues(alpha: 0.0),
                          const Color(
                            0xFF667EEA,
                          ).withValues(alpha: 0.3 * _shimmerAnimation.value),
                          const Color(0xFF48CAE4).withValues(alpha: 0.0),
                        ],
                        stops: [
                          _shimmerAnimation.value - 0.3,
                          _shimmerAnimation.value,
                          _shimmerAnimation.value + 0.3,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // Floating elements - constrained properly
            _buildFloatingElements(),

            // Main content
            SafeArea(
              child: Container(
                height: 95,
                padding: EdgeInsets.symmetric(
                  horizontal: customSpacing.md,
                  vertical: customSpacing.xs,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Enhanced Employee Badge with Avatar
                    Flexible(
                      flex: 0,
                      child: _buildAdvancedEmployeeBadge(customSpacing),
                    ),
                    SizedBox(width: customSpacing.sm),

                    // Dynamic Screen Title with Subtitle
                    Expanded(child: _buildDynamicTitle(theme, customSpacing)),

                    // No stats dashboard - clean app bar

                    // Enhanced Action Center
                    Flexible(
                      flex: 0,
                      child: _buildEnhancedActionCenter(customSpacing),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return ClipRect(
      child: Stack(
        children: [
          // Floating circle 1 - constrained within bounds
          Positioned(
            top: 10,
            right: 100,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Floating circle 2 - constrained within bounds
          Positioned(
            bottom: 10,
            left: 50,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 2.0 - _pulseAnimation.value,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF48CAE4).withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF48CAE4).withValues(alpha: 0.15),
                        width: 0.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedEmployeeBadge(CustomSpacing customSpacing) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 125, maxHeight: 40),
      child: GlassCard(
        padding: EdgeInsets.symmetric(
          horizontal: customSpacing.xs,
          vertical: customSpacing.xs,
        ),
        borderRadius: 20,
        opacity: 0.2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Avatar
            Stack(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF48CAE4), Color(0xFF667EEA)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: customSpacing.xs),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'EMPLOYEE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Youssef Hassan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicTitle(ThemeData theme, CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _getScreenTitle(),
            key: ValueKey(_selectedIndex),
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        SizedBox(height: 2),
        Text(
          _getScreenSubtitle(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildEnhancedActionCenter(CustomSpacing customSpacing) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quick Access Button
        if (_selectedIndex >= 5)
          _buildActionButton(
            Icons.home_outlined,
            'Home',
            () => setState(() => _selectedIndex = 0),
            customSpacing,
          ),

        // Notifications with Badge
        _buildNotificationButton(customSpacing),

        SizedBox(width: customSpacing.xs),

        // Enhanced Profile Menu
        _buildEnhancedProfileMenu(customSpacing),
      ],
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String tooltip,
    VoidCallback onPressed,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(right: customSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(CustomSpacing customSpacing) {
    return Container(
      margin: EdgeInsets.only(right: customSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _showNotifications,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedProfileMenu(CustomSpacing customSpacing) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'profile':
            setState(() => _selectedIndex = 3);
            break;
          case 'help':
            _showHelp();
            break;
          case 'settings':
            setState(() => _selectedIndex = 3);
            break;
          case 'logout':
            _logout();
            break;
        }
      },
      child: Container(
        width: 50,
        height: 36,
        padding: EdgeInsets.symmetric(horizontal: customSpacing.xs),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF48CAE4), Color(0xFF667EEA)],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: Colors.white,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.account_circle),
              SizedBox(width: 8),
              Text('My Profile'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'help',
          child: Row(
            children: [
              Icon(Icons.help_outline),
              SizedBox(width: 8),
              Text('Help & Support'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [Icon(Icons.logout), SizedBox(width: 8), Text('Logout')],
          ),
        ),
      ],
    );
  }

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'My Dashboard';
      case 1:
        return 'Customer Interactions';
      case 2:
        return 'My Performance';
      case 3:
        return 'My Profile';
      case 4:
        return 'Analysis Tools';
      case 5:
        return 'Text Analysis';
      case 6:
        return 'Voice Analysis';
      case 7:
        return 'Video Analysis';
      default:
        return 'Employee Portal';
    }
  }

  String _getScreenSubtitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Overview & insights • Real-time analytics';
      case 1:
        return 'Manage customer tickets • Support dashboard';
      case 2:
        return 'Track your achievements • 92% performance score';
      case 3:
        return 'Account settings & preferences';
      case 4:
        return 'AI-powered insights & analytics';
      case 5:
        return 'Text & message analysis tools';
      case 6:
        return 'Voice call analysis & insights';
      case 7:
        return 'Customer video analysis & feedback';
      default:
        return 'Professional customer service platform';
    }
  }

  void _showNotifications() {
    // Show notifications dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications_active, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Notifications'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNotificationItem(
              'New customer message',
              '2 minutes ago',
              Icons.message,
              AppColors.primary,
            ),
            _buildNotificationItem(
              'Analysis complete',
              '5 minutes ago',
              Icons.check_circle,
              AppColors.success,
            ),
            _buildNotificationItem(
              'Task deadline approaching',
              '10 minutes ago',
              Icons.schedule,
              AppColors.warning,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Mark All as Read'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    // Show help dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Help & Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              'Getting Started',
              'Learn the basics of using the app',
            ),
            _buildHelpItem(
              'Analysis Tools',
              'Understanding AI-powered insights',
            ),
            _buildHelpItem(
              'Customer Management',
              'Managing customer interactions',
            ),
            _buildHelpItem(
              'Performance Tracking',
              'Monitor your performance metrics',
            ),
            SizedBox(height: 16),
            Text(
              'Need more help?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Contact support: support@graphsmile.com\nPhone: +1 (555) 123-4567',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Contact Support'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildModernNavBar() {
    // Only show navigation for main tabs (0-4)
    final currentIndex = _selectedIndex > 4 ? 0 : _selectedIndex;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667EEA).withValues(alpha: 0.25),
            const Color(0xFF764BA2).withValues(alpha: 0.2),
            const Color(0xFF48CAE4).withValues(alpha: 0.15),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25,
            offset: const Offset(0, -10),
          ),
          BoxShadow(
            color: const Color(0xFF667EEA).withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.home_outlined,
                  Icons.home,
                  'Home',
                  0,
                  currentIndex == 0,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.support_outlined,
                  Icons.support,
                  'Support',
                  1,
                  currentIndex == 1,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.trending_up_outlined,
                  Icons.trending_up,
                  'Stats',
                  2,
                  currentIndex == 2,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.analytics_outlined,
                  Icons.analytics,
                  'Tools',
                  3,
                  currentIndex == 3,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildEnhancedNavItem(
                  Icons.person_outline,
                  Icons.person,
                  'Profile',
                  4,
                  currentIndex == 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedNavItem(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        // Add haptic feedback for better UX
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.4),
                    const Color(0xFF667EEA).withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.3),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with smooth transition
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isSelected ? filledIcon : outlinedIcon,
                key: ValueKey('$index-$isSelected'),
                color: Colors.white,
                size: isSelected ? 22 : 20,
              ),
            ),
            const SizedBox(height: 2),
            // Label with overflow protection and responsive font size
            Flexible(
              child: Container(
                constraints: const BoxConstraints(minHeight: 12),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: isSelected ? 0.2 : 0.0,
                    height: 1.0,
                  ),
                  child: Text(
                    label,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
