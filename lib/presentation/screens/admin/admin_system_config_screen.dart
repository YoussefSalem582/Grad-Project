import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/auth/animated_background_widget.dart';

class AdminSystemConfigScreen extends StatefulWidget {
  const AdminSystemConfigScreen({super.key});

  @override
  State<AdminSystemConfigScreen> createState() =>
      _AdminSystemConfigScreenState();
}

class _AdminSystemConfigScreenState extends State<AdminSystemConfigScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  final Map<String, bool> _systemSettings = {
    'enableNotifications': true,
    'allowRegistration': false,
    'maintenanceMode': false,
    'enableAnalytics': true,
    'enableLogging': true,
    'autoBackup': true,
    'enableSSL': true,
    'enableMFA': false,
  };

  final Map<String, String> _systemInfo = {
    'version': '2.1.3',
    'database': 'PostgreSQL 14.2',
    'storage': '1.2TB / 2TB',
    'uptime': '15 days, 8 hours',
    'lastBackup': '2 hours ago',
    'environment': 'Production',
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
              padding: EdgeInsets.all(customSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: customSpacing.xl * 2,
                  ), // Space for admin badge
                  _buildHeader(theme, customSpacing),
                  SizedBox(height: customSpacing.xl),
                  _buildSystemInfo(customSpacing),
                  SizedBox(height: customSpacing.xl),
                  _buildSystemSettings(customSpacing),
                  SizedBox(height: customSpacing.xl),
                  _buildQuickActions(customSpacing),
                  SizedBox(height: customSpacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing customSpacing) {
    return Container(
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(customSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.settings, color: Colors.white, size: 32),
          ),
          SizedBox(width: customSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Configuration',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  'Manage system settings and configurations',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: customSpacing.sm),
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
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 16,
                      ),
                      SizedBox(width: customSpacing.xs),
                      Text(
                        'System healthy',
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
        ],
      ),
    );
  }

  Widget _buildSystemInfo(CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Information',
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
            childAspectRatio: 1.5,
          ),
          itemCount: _systemInfo.length,
          itemBuilder: (context, index) {
            final entry = _systemInfo.entries.elementAt(index);
            return _buildInfoCard(entry.key, entry.value);
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value) {
    final color = _getInfoCardColor(title);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_getInfoIcon(title), color: color, size: 16),
              ),
              const Spacer(),
              if (title == 'storage')
                Icon(Icons.trending_up, color: AppColors.warning, size: 14),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            _formatTitle(title),
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemSettings(CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: customSpacing.md),
        Container(
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
            children: _systemSettings.entries.map((entry) {
              return _buildSettingTile(entry.key, entry.value);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(String key, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.textLight.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getSettingColor(key).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getSettingIcon(key),
              color: _getSettingColor(key),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatTitle(key),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _getSettingDescription(key),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                _systemSettings[key] = newValue;
              });
            },
            activeColor: _getSettingColor(key),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(CustomSpacing customSpacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: customSpacing.md),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2,
          children: [
            _buildActionButton(
              'Backup Now',
              Icons.backup,
              const Color(0xFF4CAF50),
              () => _performBackup(),
            ),
            _buildActionButton(
              'View Logs',
              Icons.list_alt,
              const Color(0xFF2196F3),
              () => _viewLogs(),
            ),
            _buildActionButton(
              'Clear Cache',
              Icons.clear_all,
              const Color(0xFFFF9800),
              () => _clearCache(),
            ),
            _buildActionButton(
              'Restart System',
              Icons.restart_alt,
              const Color(0xFFFF6B6B),
              () => _restartSystem(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getInfoCardColor(String key) {
    switch (key) {
      case 'version':
        return const Color(0xFF4CAF50);
      case 'database':
        return const Color(0xFF2196F3);
      case 'storage':
        return const Color(0xFFFF9800);
      case 'uptime':
        return const Color(0xFF9C27B0);
      case 'lastBackup':
        return const Color(0xFF00BCD4);
      case 'environment':
        return const Color(0xFFFF6B6B);
      default:
        return AppColors.primary;
    }
  }

  IconData _getInfoIcon(String key) {
    switch (key) {
      case 'version':
        return Icons.info;
      case 'database':
        return Icons.storage;
      case 'storage':
        return Icons.folder;
      case 'uptime':
        return Icons.timer;
      case 'lastBackup':
        return Icons.backup;
      case 'environment':
        return Icons.cloud;
      default:
        return Icons.info;
    }
  }

  Color _getSettingColor(String key) {
    switch (key) {
      case 'enableNotifications':
        return const Color(0xFF4CAF50);
      case 'allowRegistration':
        return const Color(0xFF2196F3);
      case 'maintenanceMode':
        return const Color(0xFFFF6B6B);
      case 'enableAnalytics':
        return const Color(0xFF9C27B0);
      case 'enableLogging':
        return const Color(0xFFFF9800);
      case 'autoBackup':
        return const Color(0xFF00BCD4);
      case 'enableSSL':
        return const Color(0xFF4CAF50);
      case 'enableMFA':
        return const Color(0xFFFF6B6B);
      default:
        return AppColors.primary;
    }
  }

  IconData _getSettingIcon(String key) {
    switch (key) {
      case 'enableNotifications':
        return Icons.notifications;
      case 'allowRegistration':
        return Icons.person_add;
      case 'maintenanceMode':
        return Icons.build;
      case 'enableAnalytics':
        return Icons.analytics;
      case 'enableLogging':
        return Icons.description;
      case 'autoBackup':
        return Icons.backup;
      case 'enableSSL':
        return Icons.security;
      case 'enableMFA':
        return Icons.verified_user;
      default:
        return Icons.settings;
    }
  }

  String _getSettingDescription(String key) {
    switch (key) {
      case 'enableNotifications':
        return 'Send system notifications to users';
      case 'allowRegistration':
        return 'Allow new users to register';
      case 'maintenanceMode':
        return 'Put system in maintenance mode';
      case 'enableAnalytics':
        return 'Collect usage analytics';
      case 'enableLogging':
        return 'Enable system logging';
      case 'autoBackup':
        return 'Automatically backup data';
      case 'enableSSL':
        return 'Enable SSL encryption';
      case 'enableMFA':
        return 'Require multi-factor authentication';
      default:
        return '';
    }
  }

  String _formatTitle(String key) {
    return key
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ')
        .trim();
  }

  void _performBackup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup System'),
        content: const Text(
          'Are you sure you want to perform a system backup now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('System backup initiated')),
              );
            },
            child: const Text('Start Backup'),
          ),
        ],
      ),
    );
  }

  void _viewLogs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Logs'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: Colors.black87,
            child: SingleChildScrollView(
              child: Text(
                '[2024-01-15 10:30:15] INFO: System started\n'
                '[2024-01-15 10:30:16] INFO: Database connected\n'
                '[2024-01-15 10:30:17] INFO: User authentication service started\n'
                '[2024-01-15 10:30:18] INFO: Analysis engine initialized\n'
                '[2024-01-15 10:35:22] INFO: User login: john.smith@company.com\n'
                '[2024-01-15 10:45:33] INFO: Analysis completed: TEXT_001\n'
                '[2024-01-15 11:15:44] WARN: High memory usage detected\n'
                '[2024-01-15 11:16:00] INFO: Memory cleanup completed\n',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ),
          ),
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

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
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
            child: const Text('Clear Cache'),
          ),
        ],
      ),
    );
  }

  void _restartSystem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart System'),
        content: const Text(
          'This will restart the entire system. All users will be disconnected. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('System restart initiated')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Restart', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
