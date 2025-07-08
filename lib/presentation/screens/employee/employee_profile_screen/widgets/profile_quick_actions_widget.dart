import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

class ProfileQuickActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onTimeOffRequest;
  final VoidCallback onHelpSupport;
  final VoidCallback onSignOut;

  const ProfileQuickActionsWidget({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onTimeOffRequest,
    required this.onHelpSupport,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withValues(alpha: 0.9),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.flash_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              'Edit Profile',
              Icons.edit_outlined,
              onEditProfile,
              AppColors.primary,
            ),
            _buildActionItem(
              'Change Password',
              Icons.lock_outline,
              onChangePassword,
              AppColors.secondary,
            ),
            _buildActionItem(
              'Request Time Off',
              Icons.calendar_month_outlined,
              onTimeOffRequest,
              AppColors.info,
            ),
            _buildActionItem(
              'Help & Support',
              Icons.help_outline,
              onHelpSupport,
              AppColors.warning,
            ),
            const Divider(height: 24),
            _buildActionItem(
              'Sign Out',
              Icons.logout,
              onSignOut,
              AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    String title,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
