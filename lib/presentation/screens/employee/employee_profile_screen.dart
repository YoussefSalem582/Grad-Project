import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/common/animated_background_widget.dart';
import '../../widgets/employee_screen_widgets/profile/profile.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  bool _notificationsEnabled = true;
  bool _emailAlerts = false;
  String _selectedLanguage = 'English';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedBackgroundWidget(animation: _backgroundAnimation),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ProfileHeaderWidget(
                  name: 'Youssef Hassan',
                  position: 'Customer Service Representative',
                  status: 'Active',
                  onEditPressed: () => _showEditProfileDialog(),
                ),
                const SizedBox(height: 20),
                ProfilePersonalInfoWidget(
                  name: 'Youssef Hassan',
                  email: 'youssef.hassan@company.com',
                  phone: '+20 1026855881',
                  department: 'Customer Support',
                  employeeId: '211000582',
                ),
                const SizedBox(height: 20),
                ProfileWorkInfoWidget(
                  startDate: 'January 15, 2025',
                  location: 'Giza',
                  manager: 'Dr Walaa',
                  team: 'Customer Experience',
                ),
                const SizedBox(height: 20),
                ProfileSettingsWidget(
                  notificationsEnabled: _notificationsEnabled,
                  emailAlerts: _emailAlerts,
                  selectedLanguage: _selectedLanguage,
                  onNotificationsChanged:
                      (value) => setState(() => _notificationsEnabled = value),
                  onEmailAlertsChanged:
                      (value) => setState(() => _emailAlerts = value),
                  onLanguageChanged:
                      (value) => setState(() => _selectedLanguage = value!),
                ),
                const SizedBox(height: 20),
                ProfileQuickActionsWidget(
                  onEditProfile: () => _showEditProfileDialog(),
                  onChangePassword: () => _showChangePasswordDialog(),
                  onTimeOffRequest: () => _showTimeOffRequest(),
                  onHelpSupport: () => _showHelpSupport(),
                  onSignOut: () => _showSignOutDialog(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: const Text(
              'Profile editing functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: const Text(
              'Password change functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Change'),
              ),
            ],
          ),
    );
  }

  void _showTimeOffRequest() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Request Time Off'),
            content: const Text(
              'Time off request functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Help & Support'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need help? Contact us:'),
                SizedBox(height: 8),
                Text('Email: support@graphsmile.com'),
                Text('Phone: +1 (555) 123-4567'),
                Text('Hours: 9 AM - 6 PM EST'),
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

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                  Navigator.pushReplacementNamed(context, '/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }
}
