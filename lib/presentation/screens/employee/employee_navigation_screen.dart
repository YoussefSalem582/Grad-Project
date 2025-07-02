import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/widgets.dart';
import 'employee_dashboard_screen.dart';
import 'employee_customer_interactions_screen.dart';
import 'employee_performance_screen.dart';
import 'employee_tasks_screen.dart';
import 'employee_profile_screen.dart';
import 'employee_social_analysis_screen.dart';
import 'employee_text_analysis_screen.dart';
import 'employee_voice_analysis_screen.dart';

class EmployeeNavigationScreen extends StatefulWidget {
  const EmployeeNavigationScreen({super.key});

  @override
  State<EmployeeNavigationScreen> createState() =>
      _EmployeeNavigationScreenState();
}

class _EmployeeNavigationScreenState extends State<EmployeeNavigationScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _showAnalysisOverlay = false;
  late AnimationController _overlayController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _overlayAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  final List<Widget> _screens = [
    const EmployeeDashboardScreen(),
    const EmployeeCustomerInteractionsScreen(),
    const EmployeePerformanceScreen(),
    const EmployeeTasksScreen(),
    const EmployeeProfileScreen(),
    const EmployeeSocialAnalysisScreen(),
    const EmployeeTextAnalysisScreen(),
    const EmployeeVoiceAnalysisScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _overlayAnimation = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
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
    _overlayController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      appBar: _buildEnhancedAppBar(theme, customSpacing),
      body: Stack(
        children: [
          IndexedStack(index: _selectedIndex, children: _screens),
          if (_showAnalysisOverlay) _buildAnalysisOverlay(),
        ],
      ),
      bottomNavigationBar: _buildModernNavBar(),
      floatingActionButton: _buildEnhancedAnalysisFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFF48CAE4),
              Color(0xFF667EEA),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF667EEA).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
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
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(
                            alpha: 0.1 * _shimmerAnimation.value,
                          ),
                          Colors.white.withValues(alpha: 0.0),
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

                    // Advanced Status Dashboard
                    Flexible(
                      flex: 0,
                      child: _buildAdvancedStatusDashboard(customSpacing),
                    ),

                    SizedBox(width: customSpacing.xs),

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
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
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
                      color: Colors.white.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
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
      constraints: const BoxConstraints(maxWidth: 120),
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
                    'John Smith',
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

  Widget _buildAdvancedStatusDashboard(CustomSpacing customSpacing) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Performance Score
        _buildStatusBadge(
          '92',
          'Score',
          Icons.trending_up,
          AppColors.success,
          customSpacing,
        ),
        SizedBox(width: customSpacing.xs),

        // Active Tasks
        _buildStatusBadge(
          '8',
          'Active',
          Icons.task_alt,
          AppColors.warning,
          customSpacing,
        ),
        SizedBox(width: customSpacing.xs),

        // Live Time
        _buildLiveTimeBadge(customSpacing),
      ],
    );
  }

  Widget _buildStatusBadge(
    String value,
    String label,
    IconData icon,
    Color color,
    CustomSpacing customSpacing,
  ) {
    return Container(
      constraints: const BoxConstraints(minWidth: 45, maxWidth: 60),
      padding: EdgeInsets.symmetric(horizontal: customSpacing.xs, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 10, color: Colors.white),
              SizedBox(width: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTimeBadge(CustomSpacing customSpacing) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        final timeString =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

        return Container(
          constraints: const BoxConstraints(minWidth: 45, maxWidth: 65),
          padding: EdgeInsets.symmetric(
            horizontal: customSpacing.xs,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 10, color: Colors.white),
                  SizedBox(width: 2),
                  Text(
                    timeString,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const Text(
                'Live',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 18, color: Colors.white),
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
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
            setState(() => _selectedIndex = 4);
            break;
          case 'help':
            _showHelp();
            break;
          case 'settings':
            setState(() => _selectedIndex = 4);
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
        return 'My Tasks';
      case 4:
        return 'My Profile';
      case 5:
        return 'Social Media Analysis';
      case 6:
        return 'Text Analysis';
      case 7:
        return 'Voice Analysis';
      default:
        return 'Employee Portal';
    }
  }

  String _getScreenSubtitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Overview & insights • Real-time analytics';
      case 1:
        return 'Manage customer conversations • 8 active chats';
      case 2:
        return 'Track your achievements • 92% performance score';
      case 3:
        return 'Daily tasks & assignments • 5 pending items';
      case 4:
        return 'Account settings & preferences';
      case 5:
        return 'Social media sentiment analysis';
      case 6:
        return 'Text & message analysis tools';
      case 7:
        return 'Voice call analysis & insights';
      default:
        return 'Professional customer service platform';
    }
  }

  void _toggleAnalysisOverlay() {
    setState(() {
      _showAnalysisOverlay = !_showAnalysisOverlay;
    });

    if (_showAnalysisOverlay) {
      _overlayController.forward();
    } else {
      _overlayController.reverse();
    }
  }

  void _navigateToAnalysis(int index) {
    _toggleAnalysisOverlay();
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() => _selectedIndex = index);
    });
  }

  void _quickTextAnalysis() {
    _toggleAnalysisOverlay();
    _navigateToAnalysis(6);
  }

  void _batchAnalysis() {
    _toggleAnalysisOverlay();
    // TODO: Implement batch analysis
  }

  void _showNotifications() {
    // TODO: Implement notifications
  }

  void _showHelp() {
    // TODO: Implement help
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildModernNavBar() {
    // Only show navigation for main tabs (0-4)
    final currentIndex = _selectedIndex > 4 ? 0 : _selectedIndex;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() => _selectedIndex = index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.home_outlined, 0),
                activeIcon: _buildNavIcon(Icons.home, 0, selected: true),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.chat_outlined, 1),
                activeIcon: _buildNavIcon(Icons.chat, 1, selected: true),
                label: 'Customers',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.trending_up_outlined, 2),
                activeIcon: _buildNavIcon(Icons.trending_up, 2, selected: true),
                label: 'Performance',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.assignment_outlined, 3),
                activeIcon: _buildNavIcon(Icons.assignment, 3, selected: true),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(Icons.person_outline, 4),
                activeIcon: _buildNavIcon(Icons.person, 4, selected: true),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: selected ? AppColors.primaryGradient : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: selected ? Colors.white : AppColors.textSecondary,
        size: 22,
      ),
    );
  }

  Widget _buildEnhancedAnalysisFAB() {
    return AnimatedScale(
      scale: _showAnalysisOverlay ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, right: 8),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: _showAnalysisOverlay
                ? LinearGradient(
                    colors: [
                      AppColors.warning,
                      AppColors.warning.withValues(alpha: 0.8),
                    ],
                  )
                : AppColors.accentGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    (_showAnalysisOverlay
                            ? AppColors.warning
                            : AppColors.accent)
                        .withValues(alpha: 0.6),
                blurRadius: _showAnalysisOverlay ? 25 : 15,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color:
                    (_showAnalysisOverlay
                            ? AppColors.warning
                            : AppColors.accent)
                        .withValues(alpha: 0.3),
                blurRadius: _showAnalysisOverlay ? 35 : 25,
                offset: const Offset(0, 12),
              ),
              // Additional glow for visibility
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            elevation: _showAnalysisOverlay ? 12 : 8,
            shape: const CircleBorder(),
            child: InkWell(
              borderRadius: BorderRadius.circular(32),
              onTap: _toggleAnalysisOverlay,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedRotation(
                    turns: _showAnalysisOverlay ? 0.125 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _showAnalysisOverlay ? Icons.close : Icons.analytics,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  if (!_showAnalysisOverlay)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.warning,
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
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisOverlay() {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Background overlay - excludes FAB area
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleAnalysisOverlay,
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.5 * _overlayAnimation.value,
                  ),
                ),
              ),
            ),

            // Analysis menu positioned to not overlap with FAB
            Positioned(
              left: 0,
              right: 0,
              bottom: 140, // Leave space for FAB and bottom nav
              child: Transform.scale(
                scale: _overlayAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, 50 * (1 - _overlayAnimation.value)),
                  child: _buildAnalysisMenu(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalysisMenu() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.responsiveSpacing(
          mobile: 16,
          tablet: 32,
          desktop: 48,
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: ResponsiveUtils.getContainerWidth(
          context,
          mobile: MediaQuery.of(context).size.width * 0.95,
          tablet: 600,
          desktop: 700,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            ResponsiveUtils.getBorderRadius(
              context,
              mobile: 20,
              tablet: 24,
              desktop: 28,
            ),
          ),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: ResponsiveUtils.getCardElevation(context) * 4,
              offset: Offset(0, ResponsiveUtils.getCardElevation(context) * 2),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.1),
              blurRadius: ResponsiveUtils.getCardElevation(context) * 6,
              offset: Offset(0, ResponsiveUtils.getCardElevation(context)),
            ),
          ],
        ),
        padding: context.responsivePadding(mobile: 20, tablet: 24, desktop: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - Responsive
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    context.responsiveSpacing(
                      mobile: 10,
                      tablet: 12,
                      desktop: 14,
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.getBorderRadius(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 18,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: Colors.white,
                    size: ResponsiveUtils.getIconSize(
                      context,
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                    ),
                  ),
                ),
                SizedBox(
                  width: context.responsiveSpacing(
                    mobile: 12,
                    tablet: 16,
                    desktop: 20,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analysis Tools',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFontSize(
                            mobile: 18,
                            tablet: 20,
                            desktop: 22,
                          ),
                        ),
                      ),
                      Text(
                        'AI-powered customer insights',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFontSize(
                            mobile: 13,
                            tablet: 14,
                            desktop: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _toggleAnalysisOverlay,
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveUtils.getIconSize(
                      context,
                      mobile: 20,
                      tablet: 22,
                      desktop: 24,
                    ),
                  ),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            SizedBox(
              height: context.responsiveSpacing(
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),

            // Analysis Options - Responsive Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = MediaQuery.of(context).size.width;
                final isTablet = screenWidth > 600;
                final crossAxisCount = isTablet ? 3 : 1;
                final childAspectRatio = isTablet ? 0.85 : 3.5;

                if (crossAxisCount == 1) {
                  // Mobile layout - vertical list
                  return Column(
                    children: [
                      _buildAnalysisOptionHorizontal(
                        'Social Media',
                        'Analyze posts, comments & mentions',
                        Icons.link,
                        AppColors.primary,
                        () => _navigateToAnalysis(5),
                      ),
                      const SizedBox(height: 12),
                      _buildAnalysisOptionHorizontal(
                        'Text Analysis',
                        'Messages, emails & feedback',
                        Icons.text_fields,
                        AppColors.secondary,
                        () => _navigateToAnalysis(6),
                      ),
                      const SizedBox(height: 12),
                      _buildAnalysisOptionHorizontal(
                        'Voice Analysis',
                        'Calls, recordings & audio',
                        Icons.mic,
                        AppColors.success,
                        () => _navigateToAnalysis(7),
                      ),
                    ],
                  );
                } else {
                  // Tablet layout - grid
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: childAspectRatio,
                    children: [
                      _buildAnalysisOption(
                        'Social Media',
                        'Posts & mentions',
                        Icons.link,
                        AppColors.primary,
                        () => _navigateToAnalysis(5),
                      ),
                      _buildAnalysisOption(
                        'Text Analysis',
                        'Messages & feedback',
                        Icons.text_fields,
                        AppColors.secondary,
                        () => _navigateToAnalysis(6),
                      ),
                      _buildAnalysisOption(
                        'Voice Analysis',
                        'Calls & recordings',
                        Icons.mic,
                        AppColors.success,
                        () => _navigateToAnalysis(7),
                      ),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: ModernButton(
                    onPressed: _quickTextAnalysis,
                    style: ModernButtonStyle.outlined,
                    text: 'Quick Text',
                    icon: Icons.flash_on,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ModernButton(
                    onPressed: _batchAnalysis,
                    style: ModernButtonStyle.secondary,
                    text: 'Batch Process',
                    icon: Icons.batch_prediction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisOptionHorizontal(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
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
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisOption(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
