import 'package:flutter/material.dart';
import '../../../core/core.dart';

class AdminSystemConfigScreen extends StatefulWidget {
  const AdminSystemConfigScreen({super.key});

  @override
  State<AdminSystemConfigScreen> createState() =>
      _AdminSystemConfigScreenState();
}

class _AdminSystemConfigScreenState extends State<AdminSystemConfigScreen> {
  bool _autoBackup = true;
  bool _darkModeEnabled = false;
  bool _notificationsEnabled = true;
  bool _analyticsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTimezone = 'UTC-8 (Pacific)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSystemSettings(),
            const SizedBox(height: 24),
            _buildSecuritySettings(),
            const SizedBox(height: 24),
            _buildIntegrationSettings(),
            const SizedBox(height: 24),
            _buildDataManagement(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Configuration',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Manage system-wide settings and configurations',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSystemSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: AppColors.primary),
                const SizedBox(width: 12),
                Text(
                  'General Settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSwitchTile(
              'Auto Backup',
              'Automatically backup system data daily',
              _autoBackup,
              (value) => setState(() => _autoBackup = value),
            ),
            _buildSwitchTile(
              'Dark Mode',
              'Enable dark theme for the application',
              _darkModeEnabled,
              (value) => setState(() => _darkModeEnabled = value),
            ),
            _buildSwitchTile(
              'System Notifications',
              'Receive system alerts and notifications',
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
            ),
            _buildSwitchTile(
              'Analytics Collection',
              'Collect anonymous usage analytics',
              _analyticsEnabled,
              (value) => setState(() => _analyticsEnabled = value),
            ),
            const SizedBox(height: 16),
            _buildDropdownSetting(
              'Language',
              _selectedLanguage,
              ['English', 'Spanish', 'French', 'German', 'Chinese'],
              (value) => setState(() => _selectedLanguage = value!),
            ),
            const SizedBox(height: 16),
            _buildDropdownSetting(
              'Timezone',
              _selectedTimezone,
              [
                'UTC-8 (Pacific)',
                'UTC-5 (Eastern)',
                'UTC+0 (GMT)',
                'UTC+1 (CET)',
              ],
              (value) => setState(() => _selectedTimezone = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: AppColors.error),
                const SizedBox(width: 12),
                Text(
                  'Security Settings',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionTile(
              'Password Policy',
              'Configure password requirements',
              Icons.lock,
              () => _showDialog('Password Policy'),
            ),
            _buildActionTile(
              'Two-Factor Authentication',
              'Manage 2FA settings for admin accounts',
              Icons.verified_user,
              () => _showDialog('2FA Settings'),
            ),
            _buildActionTile(
              'Session Management',
              'Configure session timeouts and limits',
              Icons.timer,
              () => _showDialog('Session Management'),
            ),
            _buildActionTile(
              'API Security',
              'Manage API keys and access tokens',
              Icons.key,
              () => _showDialog('API Security'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegrationSettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.integration_instructions,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Integrations',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildIntegrationTile('Slack', 'Connected', true),
            _buildIntegrationTile('Microsoft Teams', 'Not Connected', false),
            _buildIntegrationTile('Salesforce', 'Connected', true),
            _buildIntegrationTile('Zendesk', 'Connected', true),
            _buildIntegrationTile('Google Workspace', 'Not Connected', false),
          ],
        ),
      ),
    );
  }

  Widget _buildDataManagement() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.storage, color: AppColors.warning),
                const SizedBox(width: 12),
                Text(
                  'Data Management',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionTile(
              'Database Backup',
              'Create and manage database backups',
              Icons.backup,
              () => _showDialog('Database Backup'),
            ),
            _buildActionTile(
              'Data Retention',
              'Configure data retention policies',
              Icons.schedule,
              () => _showDialog('Data Retention'),
            ),
            _buildActionTile(
              'Export Data',
              'Export system data for analysis',
              Icons.download,
              () => _showDialog('Export Data'),
            ),
            _buildActionTile(
              'Clear Cache',
              'Clear system cache and temporary files',
              Icons.cleaning_services,
              () => _clearCache(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDropdownSetting(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem(value: option, child: Text(option));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildIntegrationTile(String name, String status, bool isConnected) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isConnected
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.textSecondary.withValues(alpha: 0.1),
        child: Icon(
          isConnected ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isConnected ? AppColors.success : AppColors.textSecondary,
        ),
      ),
      title: Text(name),
      subtitle: Text(status),
      trailing: TextButton(
        onPressed: () => _configureIntegration(name),
        child: Text(isConnected ? 'Configure' : 'Connect'),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('$title configuration would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the system cache?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _configureIntegration(String name) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Configuring $name integration...')));
  }
}
