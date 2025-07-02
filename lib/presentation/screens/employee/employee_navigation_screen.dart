import 'package:flutter/material.dart';
import '../../../core/core.dart';
import 'employee_dashboard_screen.dart';
import 'employee_customer_interactions_screen.dart';
import 'employee_performance_screen.dart';
import 'employee_tasks_screen.dart';
import 'employee_profile_screen.dart';
import 'employee_social_analysis_screen.dart';
import 'employee_text_analysis_screen.dart';
import 'employee_voice_analysis_screen.dart';

class EmployeeNavigationScreen extends StatefulWidget {
  const EmployeeNavigationScreen({super.key});

  @override
  State<EmployeeNavigationScreen> createState() =>
      _EmployeeNavigationScreenState();
}

class _EmployeeNavigationScreenState extends State<EmployeeNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EmployeeDashboardScreen(),
    const EmployeeCustomerInteractionsScreen(),
    const EmployeePerformanceScreen(),
    const EmployeeTasksScreen(),
    const EmployeeProfileScreen(),
    const EmployeeSocialAnalysisScreen(),
    const EmployeeTextAnalysisScreen(),
    const EmployeeVoiceAnalysisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.secondary,
                    AppColors.secondary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, size: 16, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    'EMPLOYEE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _getScreenTitle(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          if (_selectedIndex >= 5)
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => setState(() => _selectedIndex = 0),
              tooltip: 'Back to Dashboard',
            ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show employee notifications
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline),
                    SizedBox(width: 8),
                    Text('Help & Support'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _selectedIndex < 5
          ? NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: Colors.white,
              elevation: 8,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_outlined),
                  selectedIcon: Icon(Icons.chat),
                  label: 'Customers',
                ),
                NavigationDestination(
                  icon: Icon(Icons.trending_up_outlined),
                  selectedIcon: Icon(Icons.trending_up),
                  label: 'Performance',
                ),
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: 'Tasks',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
      floatingActionButton: _selectedIndex < 5
          ? FloatingActionButton(
              onPressed: _showAnalysisMenu,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.analytics),
              tooltip: 'Analysis Tools',
            )
          : null,
    );
  }

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'My Dashboard';
      case 1:
        return 'Customer Interactions';
      case 2:
        return 'My Performance';
      case 3:
        return 'My Tasks';
      case 4:
        return 'My Profile';
      case 5:
        return 'Social Media Analysis';
      case 6:
        return 'Text Analysis';
      case 7:
        return 'Voice Analysis';
      default:
        return 'Employee Portal';
    }
  }

  void _showAnalysisMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
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
            Text(
              'Analysis Tools',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose an analysis tool to start working with customer data',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
              children: [
                _buildAnalysisOption(
                  icon: Icons.link,
                  title: 'Social Media',
                  subtitle: 'Analyze social posts',
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 5);
                  },
                ),
                _buildAnalysisOption(
                  icon: Icons.text_fields,
                  title: 'Text',
                  subtitle: 'Analyze messages',
                  color: AppColors.secondary,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 6);
                  },
                ),
                _buildAnalysisOption(
                  icon: Icons.mic,
                  title: 'Voice',
                  subtitle: 'Analyze calls',
                  color: AppColors.success,
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 7);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
