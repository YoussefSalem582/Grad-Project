import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/auth/animated_background_widget.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  final Map<String, dynamic> _adminProfile = {
    'name': 'Youssef Hassan',
    'email': 'Youssef.salem.hassan582@gmail.com',
    'role': 'System Administrator',
    'department': 'IT Operations',
    'joinDate': 'January 2023',
    'lastLogin': '2 hours ago',
    'avatar': 'A',
    'phone': '+20 1026855881',
    'location': 'Giza, Egypt',
    'permissions': [
      'User Management',
      'System Configuration',
      'Ticket Management',
      'Analytics Access',
      'Security Settings',
    ],
  };

  final List<Map<String, dynamic>> _recentActivities = [
    {
      'action': 'Updated system configuration',
      'time': '2 hours ago',
      'type': 'config',
      'icon': Icons.settings,
      'color': Color(0xFF2196F3),
    },
    {
      'action': 'Resolved critical ticket TK-002',
      'time': '4 hours ago',
      'type': 'ticket',
      'icon': Icons.confirmation_number,
      'color': Color(0xFF4CAF50),
    },
    {
      'action': 'Added new user to system',
      'time': '1 day ago',
      'type': 'user',
      'icon': Icons.person_add,
      'color': Color(0xFFFF9800),
    },
    {
      'action': 'Generated monthly report',
      'time': '2 days ago',
      'type': 'report',
      'icon': Icons.analytics,
      'color': Color(0xFF9C27B0),
    },
  ];

  final Map<String, Map<String, dynamic>> _profileStats = {
    'managedUsers': {
      'value': '15',
      'label': 'Managed Users',
      'icon': Icons.group,
      'color': Color(0xFF4CAF50),
    },
    'resolvedTickets': {
      'value': '34',
      'label': 'Resolved Tickets',
      'icon': Icons.check_circle,
      'color': Color(0xFF2196F3),
    },
    'systemUptime': {
      'value': '93.9%',
      'label': 'System Uptime',
      'icon': Icons.trending_up,
      'color': Color(0xFFFF9800),
    },
    'securityScore': {
      'value': '82/100',
      'label': 'Security Score',
      'icon': Icons.security,
      'color': Color(0xFF9C27B0),
    },
  };

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
              child: Column(
                children: [
                  SizedBox(
                    height: customSpacing.xl * 2,
                  ), // Space for admin badge
                  _buildProfileHeader(theme, customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildProfileStats(customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildProfileDetails(customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildRecentActivity(customSpacing),
                  SizedBox(height: customSpacing.lg),
                  _buildActionButtons(customSpacing),
                  SizedBox(height: customSpacing.xl), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B6B).withValues(alpha: 0.1),
              const Color(0xFFFF8E53).withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFFFF6B6B),
                  child: Text(
                    _adminProfile['avatar'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(width: customSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _adminProfile['name'],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: customSpacing.xs),
                      Text(
                        _adminProfile['role'],
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[300],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: customSpacing.xs),
                      Text(
                        _adminProfile['department'],
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _showEditProfileDialog,
                  icon: const Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: customSpacing.md),
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
                  Icon(Icons.verified_user, color: AppColors.success, size: 16),
                  SizedBox(width: customSpacing.xs),
                  Text(
                    'Admin Access • Last login ${_adminProfile['lastLogin']}',
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
    );
  }

  Widget _buildProfileStats(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Admin Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: customSpacing.md),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: _profileStats.length,
            itemBuilder: (context, index) {
              final entry = _profileStats.entries.elementAt(index);
              return _buildStatCard(entry.key, entry.value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String key, Map<String, dynamic> stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stat['color'].withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: stat['color'].withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: stat['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(stat['icon'], color: stat['color'], size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            stat['value'],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: stat['color'],
            ),
          ),
          Text(
            stat['label'],
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.md),
            _buildDetailRow(Icons.email, 'Email', _adminProfile['email']),
            SizedBox(height: customSpacing.sm),
            _buildDetailRow(Icons.phone, 'Phone', _adminProfile['phone']),
            SizedBox(height: customSpacing.sm),
            _buildDetailRow(
              Icons.location_on,
              'Location',
              _adminProfile['location'],
            ),
            SizedBox(height: customSpacing.sm),
            _buildDetailRow(
              Icons.calendar_today,
              'Join Date',
              _adminProfile['joinDate'],
            ),
            SizedBox(height: customSpacing.md),
            Text(
              'Permissions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (_adminProfile['permissions'] as List<String>)
                  .map((permission) => _buildPermissionChip(permission))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionChip(String permission) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        permission,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildRecentActivity(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Container(
        padding: EdgeInsets.all(customSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: customSpacing.md),
            ..._recentActivities.map(
              (activity) => _buildActivityItem(activity, customSpacing),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    Map<String, dynamic> activity,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: activity['color'].withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(activity['icon'], color: activity['color'], size: 16),
          ),
          SizedBox(width: customSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['action'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  activity['time'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showSecuritySettingsDialog,
                  icon: const Icon(Icons.security, color: Colors.white),
                  label: const Text(
                    'Security Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: EdgeInsets.symmetric(vertical: customSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: customSpacing.sm),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _showNotificationSettingsDialog,
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  label: const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C27B0),
                    padding: EdgeInsets.symmetric(vertical: customSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showLogoutDialog,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                padding: EdgeInsets.symmetric(vertical: customSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing form would be implemented here'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showSecuritySettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Security Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.fingerprint),
              title: const Text('Two-Factor Authentication'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Login History'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Notifications'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('SMS Notifications'),
              trailing: Switch(value: false, onChanged: (value) {}),
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security Alerts'),
              trailing: Switch(value: true, onChanged: (value) {}),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout logic here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
