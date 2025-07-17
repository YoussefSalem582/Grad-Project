import 'package:flutter/material.dart';
import '../../../core/core.dart';

/// Enhanced Analysis App Bar matching the employee app bar style
class AnalysisAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onNotificationPressed;
  final bool hasUnreadNotifications;
  final int? notificationCount;

  const AnalysisAppBar({
    super.key,
    required this.title,
    this.subtitle = 'Analysis Tools',
    this.onNotificationPressed,
    this.hasUnreadNotifications = false,
    this.notificationCount,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF667EEA),
            size: 18,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          // App Logo/Icon - Using actual app icon asset
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to analysis icon if asset fails to load
                  return const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ),
          ),

          // Title Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  subtitle,
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
        // Conditional notification button
        if (onNotificationPressed != null) ...[
          Stack(
            children: [
              IconButton(
                onPressed: onNotificationPressed,
                icon: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
              if (hasUnreadNotifications) ...[
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding:
                        notificationCount != null
                            ? const EdgeInsets.all(4)
                            : null,
                    decoration: const BoxDecoration(
                      color: Color(0xFF667EEA),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child:
                        notificationCount != null
                            ? Text(
                              notificationCount! > 99
                                  ? '99+'
                                  : '$notificationCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                            : null,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(width: 8),
        ],

        // Analysis tools menu
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuSelection(context, value),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'text',
                  child: _buildMenuItem(Icons.text_fields, 'Text Analysis'),
                ),
                PopupMenuItem(
                  value: 'voice',
                  child: _buildMenuItem(Icons.mic, 'Voice Analysis'),
                ),
                PopupMenuItem(
                  value: 'video',
                  child: _buildMenuItem(Icons.videocam, 'Video Analysis'),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'tools',
                  child: _buildMenuItem(Icons.build, 'Analysis Tools'),
                ),
                PopupMenuItem(
                  value: 'dashboard',
                  child: _buildMenuItem(Icons.dashboard, 'Dashboard'),
                ),
              ],
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.analytics_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'text':
        Navigator.of(context).pushReplacementNamed('/text-analysis');
        break;
      case 'voice':
        Navigator.of(context).pushReplacementNamed('/voice-analysis');
        break;
      case 'video':
        Navigator.of(context).pushReplacementNamed('/video-analysis');
        break;
      case 'tools':
        // Navigate to analysis tools or employee screen
        Navigator.of(context).pop();
        break;
      case 'dashboard':
        Navigator.of(context).pushReplacementNamed('/employee');
        break;
    }
  }
}
