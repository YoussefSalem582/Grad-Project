import 'package:flutter/material.dart';
import '../../../core/core.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoRefreshEnabled = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _soundAlertsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC-5 (Eastern)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprise Settings'),
        actions: [
          IconButton(
            onPressed: () => _exportSettings(),
            icon: const Icon(Icons.file_download_outlined),
            tooltip: 'Export Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileCard(),
            const SizedBox(height: 24),
            _buildNotificationSettings(),
            const SizedBox(height: 24),
            _buildDisplaySettings(),
            const SizedBox(height: 24),
            _buildSystemSettings(),
            const SizedBox(height: 24),
            _buildIntegrationSettings(),
            const SizedBox(height: 24),
            _buildAdvancedSettings(),
            const SizedBox(height: 24),
            _buildSupportCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Profile',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.accent,
                child: const Text(
                  'A',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'admin@company.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Enterprise Administrator',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _editProfile(),
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notification Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Push Notifications',
            'Receive push notifications for urgent alerts',
            _notificationsEnabled,
            (value) => setState(() => _notificationsEnabled = value),
          ),
          _buildSwitchTile(
            'Sound Alerts',
            'Play sound for urgent customer issues',
            _soundAlertsEnabled,
            (value) => setState(() => _soundAlertsEnabled = value),
          ),
          _buildSwitchTile(
            'Auto Refresh',
            'Automatically refresh dashboard data',
            _autoRefreshEnabled,
            (value) => setState(() => _autoRefreshEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplaySettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Display Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchTile(
            'Dark Mode',
            'Enable dark theme for better visibility',
            _darkModeEnabled,
            (value) => setState(() => _darkModeEnabled = value),
          ),
          const SizedBox(height: 16),
          _buildDropdownTile(
            'Language',
            'Select interface language',
            _selectedLanguage,
            ['English', 'Spanish', 'French', 'German', 'Chinese'],
            (value) => setState(() => _selectedLanguage = value!),
          ),
          const SizedBox(height: 16),
          _buildDropdownTile(
            'Timezone',
            'Select your timezone for accurate timestamps',
            _selectedTimezone,
            [
              'UTC-8 (Pacific)',
              'UTC-5 (Eastern)',
              'UTC+0 (GMT)',
              'UTC+1 (CET)',
              'UTC+8 (China)',
            ],
            (value) => setState(() => _selectedTimezone = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'Data Retention',
            'Configure how long data is stored',
            Icons.storage,
            () => _configureDataRetention(),
          ),
          _buildSettingsTile(
            'Backup & Sync',
            'Manage data backup and synchronization',
            Icons.backup,
            () => _configureBackup(),
          ),
          _buildSettingsTile(
            'Security Settings',
            'Configure security and access controls',
            Icons.security,
            () => _configureecurity(),
          ),
          _buildSettingsTile(
            'API Configuration',
            'Manage API endpoints and keys',
            Icons.api,
            () => _configureAPI(),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Integrations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildIntegrationTile(
            'Slack Integration',
            'Connect with Slack for notifications',
            Icons.chat,
            true,
            () => _toggleSlack(),
          ),
          _buildIntegrationTile(
            'Salesforce CRM',
            'Sync customer data with Salesforce',
            Icons.business,
            false,
            () => _toggleSalesforce(),
          ),
          _buildIntegrationTile(
            'Microsoft Teams',
            'Send alerts to Microsoft Teams',
            Icons.group,
            true,
            () => _toggleTeams(),
          ),
          _buildIntegrationTile(
            'Zendesk',
            'Integrate with Zendesk ticketing',
            Icons.support_agent,
            false,
            () => _toggleZendesk(),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Advanced Settings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'AI Model Configuration',
            'Configure emotion analysis models',
            Icons.psychology,
            () => _configureAIModels(),
          ),
          _buildSettingsTile(
            'Custom Workflows',
            'Set up custom escalation workflows',
            Icons.account_tree,
            () => _configureWorkflows(),
          ),
          _buildSettingsTile(
            'Report Templates',
            'Create custom report templates',
            Icons.description,
            () => _configureReports(),
          ),
          _buildSettingsTile(
            'User Management',
            'Manage team members and permissions',
            Icons.people_alt,
            () => _manageUsers(),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.enterpriseCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support & Help',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'Help Center',
            'Access documentation and guides',
            Icons.help_center,
            () => _openHelpCenter(),
          ),
          _buildSettingsTile(
            'Contact Support',
            'Get help from our enterprise support team',
            Icons.support,
            () => _contactSupport(),
          ),
          _buildSettingsTile(
            'Feature Requests',
            'Request new features for your organization',
            Icons.lightbulb,
            () => _submitFeatureRequest(),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CustomerSense Pro',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Version 2.1.0 (Enterprise)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _checkForUpdates(),
                child: const Text('Check for Updates'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
      ),
    );
  }

  Widget _buildDropdownTile(
    String title,
    String subtitle,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textLight),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            underline: const SizedBox(),
            isExpanded: true,
            items: options.map((option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.accent),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildIntegrationTile(
    String title,
    String subtitle,
    IconData icon,
    bool isConnected,
    VoidCallback onTap,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.accent),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isConnected
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.textLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isConnected ? 'Connected' : 'Not Connected',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isConnected ? AppColors.success : AppColors.textLight,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  // Settings action methods
  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile editing feature coming soon')),
    );
  }

  void _configureDataRetention() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data retention configuration coming soon')),
    );
  }

  void _configureBackup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup configuration coming soon')),
    );
  }

  void _configureecurity() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security settings coming soon')),
    );
  }

  void _configureAPI() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API configuration coming soon')),
    );
  }

  void _toggleSlack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Slack integration coming soon')),
    );
  }

  void _toggleSalesforce() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salesforce integration coming soon')),
    );
  }

  void _toggleTeams() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Teams integration coming soon')),
    );
  }

  void _toggleZendesk() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Zendesk integration coming soon')),
    );
  }

  void _configureAIModels() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('AI model configuration coming soon')),
    );
  }

  void _configureWorkflows() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workflow configuration coming soon')),
    );
  }

  void _configureReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Report template configuration coming soon'),
      ),
    );
  }

  void _manageUsers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User management coming soon')),
    );
  }

  void _openHelpCenter() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Help center coming soon')));
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Support contact coming soon')),
    );
  }

  void _submitFeatureRequest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature request submission coming soon')),
    );
  }

  void _checkForUpdates() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Update check coming soon')));
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings export coming soon')),
    );
  }
}

