import 'package:flutter/material.dart';
import '../../../../core/core.dart';

/// Enhanced app bar widget for admin navigation screen
class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Animation<double> pulseAnimation;
  final int selectedIndex;
  final VoidCallback onNotificationPressed;
  final Function(String) onProfileMenuSelected;

  const AdminAppBar({
    super.key,
    required this.pulseAnimation,
    required this.selectedIndex,
    required this.onNotificationPressed,
    required this.onProfileMenuSelected,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 100,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667EEA).withValues(alpha: 0.15),
              const Color(0xFF764BA2).withValues(alpha: 0.12),
              const Color(0xFFFF6B6B).withValues(alpha: 0.08),
            ],
          ),
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // Admin Badge and Title
                Expanded(child: _buildAdminTitle()),

                // Action Center
                _buildActionCenter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            AnimatedBuilder(
              animation: pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: pulseAnimation.value,
                  child: Container(
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 10,
                    //   vertical: 4,
                    // ),
                    // decoration: BoxDecoration(
                    //   gradient: const LinearGradient(
                    //     colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                    //   ),
                    //   borderRadius: BorderRadius.circular(15),
                    //   boxShadow: [
                    //     BoxShadow(
                    //       color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                    //       blurRadius: 6,
                    //       offset: const Offset(0, 2),
                    //     ),
                    //   ],
                    // ),
                    // child: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     const Icon(
                    //       Icons.admin_panel_settings,
                    //       size: 14,
                    //       color: Colors.white,
                    //     ),
                    //     const SizedBox(width: 6),
                    //     Text(
                    //       'ADMIN',
                    //       style: const TextStyle(
                    //         color: Colors.white,
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 11,
                    //         letterSpacing: 0.5,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _getScreenTitle(),
            key: ValueKey(selectedIndex),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _getScreenSubtitle(),
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCenter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Notifications
        _buildNotificationButton(),
        const SizedBox(width: 12),

        // Profile Menu
        _buildProfileMenu(),
      ],
    );
  }

  Widget _buildNotificationButton() {
    const int unreadCount = 2; // This would come from state management

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onNotificationPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  unreadCount > 0
                      ? Icons.notifications_active
                      : Icons.notifications_outlined,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              if (unreadCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenu() {
    return PopupMenuButton<String>(
      onSelected: onProfileMenuSelected,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 14),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
              ),
            ),
          ],
        ),
      ),
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.account_circle),
                  SizedBox(width: 8),
                  Text('Admin Profile'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings),
                  SizedBox(width: 8),
                  Text('System Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline),
                  SizedBox(width: 8),
                  Text('Help & Documentation'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Logout', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
    );
  }

  String _getScreenTitle() {
    switch (selectedIndex) {
      case 0:
        return 'Admin Dashboard';
      case 1:
        return 'User Management';
      case 2:
        return 'Support Tickets';
      case 3:
        return 'System Configuration';
      case 4:
        return 'Admin Profile';
      default:
        return 'Admin Portal';
    }
  }

  String _getScreenSubtitle() {
    switch (selectedIndex) {
      case 0:
        return 'System overview and analytics';
      case 1:
        return 'Manage users, roles, and permissions';
      case 2:
        return 'Handle support requests and issues';
      case 3:
        return 'Configure system settings and parameters';
      case 4:
        return 'Manage your admin account';
      default:
        return 'Administrative control center';
    }
  }
}
