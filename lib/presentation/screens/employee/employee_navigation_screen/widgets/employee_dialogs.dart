import 'package:flutter/material.dart';
import '../../../../../core/core.dart';

/// Employee-specific dialog utilities
class EmployeeDialogs {
  /// Show notifications dialog
  static void showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _NotificationsDialog(),
    );
  }

  /// Show help and support dialog
  static void showHelp(BuildContext context) {
    showDialog(context: context, builder: (context) => const _HelpDialog());
  }

  /// Show employee quick actions bottom sheet
  static void showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const _QuickActionsSheet(),
    );
  }

  /// Show feedback dialog
  static void showFeedback(BuildContext context) {
    showDialog(context: context, builder: (context) => const _FeedbackDialog());
  }
}

/// Notifications Dialog Widget
class _NotificationsDialog extends StatelessWidget {
  const _NotificationsDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.notifications_active,
              color: Color(0xFF667EEA),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text('Notifications'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView(
          children: [
            _buildNotificationItem(
              icon: Icons.schedule,
              title: 'Shift Reminder',
              subtitle: 'Your shift starts in 30 minutes',
              time: '2 min ago',
              isUnread: true,
            ),
            _buildNotificationItem(
              icon: Icons.star,
              title: 'Performance Update',
              subtitle: 'Great job on customer satisfaction!',
              time: '1 hour ago',
              isUnread: true,
            ),
            _buildNotificationItem(
              icon: Icons.message,
              title: 'New Customer Inquiry',
              subtitle: 'A customer needs assistance with their order',
              time: '2 hours ago',
              isUnread: false,
            ),
            _buildNotificationItem(
              icon: Icons.system_update,
              title: 'System Update',
              subtitle: 'New features are now available',
              time: '1 day ago',
              isUnread: false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Mark All Read'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isUnread
                ? const Color(0xFF667EEA).withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              isUnread
                  ? const Color(0xFF667EEA).withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF667EEA)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight:
                              isUnread ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF667EEA),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Help Dialog Widget
class _HelpDialog extends StatelessWidget {
  const _HelpDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.help_outline,
              color: Color(0xFF667EEA),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text('Help & Support'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHelpItem(
            icon: Icons.quiz,
            title: 'Frequently Asked Questions',
            onTap: () {},
          ),
          _buildHelpItem(
            icon: Icons.video_library,
            title: 'Video Tutorials',
            onTap: () {},
          ),
          _buildHelpItem(
            icon: Icons.chat,
            title: 'Live Chat Support',
            onTap: () {},
          ),
          _buildHelpItem(
            icon: Icons.phone,
            title: 'Call Support',
            onTap: () {},
          ),
          _buildHelpItem(
            icon: Icons.email,
            title: 'Email Support',
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
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF667EEA)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

/// Quick Actions Bottom Sheet
class _QuickActionsSheet extends StatelessWidget {
  const _QuickActionsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.analytics,
                  title: 'Quick Analysis',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.message,
                  title: 'Send Message',
                  onTap: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.schedule,
                  title: 'Check Schedule',
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.feedback,
                  title: 'Send Feedback',
                  onTap: () => EmployeeDialogs.showFeedback(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF667EEA).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF667EEA).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF667EEA), size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Feedback Dialog Widget
class _FeedbackDialog extends StatefulWidget {
  const _FeedbackDialog();

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Send Feedback'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How would you rate your experience?'),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _rating = index + 1),
                child: Icon(
                  Icons.star,
                  color: index < _rating ? Colors.amber : Colors.grey[300],
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text('Additional Comments (optional)'),
          const SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your thoughts...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed:
              _rating > 0
                  ? () {
                    // TODO: Submit feedback
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Thank you for your feedback!'),
                      ),
                    );
                  }
                  : null,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
}
