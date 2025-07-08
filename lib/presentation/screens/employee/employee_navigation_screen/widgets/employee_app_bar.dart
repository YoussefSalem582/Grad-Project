import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

/// Enhanced Employee App Bar with animations and interactions
class EmployeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<double> shimmerAnimation;
  final Animation<double> pulseAnimation;
  final int selectedIndex;
  final VoidCallback onNotificationPressed;
  final VoidCallback onProfilePressed;
  final Function(String) onProfileMenuSelected;

  const EmployeeAppBar({
    super.key,
    required this.shimmerAnimation,
    required this.pulseAnimation,
    required this.selectedIndex,
    required this.onNotificationPressed,
    required this.onProfilePressed,
    required this.onProfileMenuSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // App Logo/Icon
          Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Dynamic Title based on selected screen
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: shimmerAnimation,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback:
                          (bounds) => LinearGradient(
                            colors: const [
                              Color(0xFF333333),
                              Color(0xFF667EEA),
                              Color(0xFF333333),
                            ],
                            stops: [0.0, shimmerAnimation.value, 1.0],
                          ).createShader(bounds),
                      child: Text(
                        _getScreenTitle(selectedIndex),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                Text(
                  'Employee Portal',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Notification Button
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: pulseAnimation.value,
              child: Stack(
                children: [
                  IconButton(
                    onPressed: onNotificationPressed,
                    icon: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: 24,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF667EEA),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Profile Menu
        PopupMenuButton<String>(
          onSelected: onProfileMenuSelected,
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'home',
                  child: _buildMenuItem(Icons.home, 'Dashboard'),
                ),
                PopupMenuItem(
                  value: 'profile',
                  child: _buildMenuItem(Icons.person, 'My Profile'),
                ),
                PopupMenuItem(
                  value: 'help',
                  child: _buildMenuItem(Icons.help_outline, 'Help & Support'),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: _buildMenuItem(Icons.settings, 'Settings'),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'logout',
                  child: _buildMenuItem(
                    Icons.logout,
                    'Logout',
                    isDestructive: true,
                  ),
                ),
              ],
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    bool isDestructive = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isDestructive ? Colors.red : null),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: isDestructive ? Colors.red : null,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Performance';
      case 2:
        return 'Analytics';
      case 3:
        return 'Profile';
      case 4:
        return 'Customer Support';
      case 5:
        return 'Analysis Tools';
      case 6:
        return 'Video Analysis';
      default:
        return 'EmoSense';
    }
  }
}
