import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../data/data.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  String _selectedTab = 'users';
  String _searchQuery = '';

  // Mock data
  final List<UserProfile> _users = [
    UserProfile(
      id: '001',
      name: 'John Smith',
      email: 'john.smith@company.com',
      role: UserRole.employee,
      department: 'Customer Service',
      lastLogin: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    UserProfile(
      id: '002',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@company.com',
      role: UserRole.admin,
      department: 'IT Management',
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    UserProfile(
      id: '003',
      name: 'Mike Chen',
      email: 'mike.chen@company.com',
      role: UserRole.employee,
      department: 'Sales Support',
      lastLogin: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<String> _departments = [
    'Customer Service',
    'Sales Support',
    'Technical Support',
    'IT Management',
    'Quality Assurance',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          Expanded(
            child: _selectedTab == 'users'
                ? _buildUsersTab()
                : _buildDepartmentsTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Management',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Manage users, roles, and departments',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              filled: true,
              fillColor: AppColors.background,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTab('users', 'Users', Icons.people),
          _buildTab('departments', 'Departments', Icons.business),
        ],
      ),
    );
  }

  Widget _buildTab(String key, String label, IconData icon) {
    final isSelected = _selectedTab == key;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = key;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    final filteredUsers = _users
        .where(
          (user) =>
              user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user.department.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user);
      },
    );
  }

  Widget _buildUserCard(UserProfile user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: user.role == UserRole.admin
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.secondary.withValues(alpha: 0.2),
              child: Icon(
                user.role == UserRole.admin
                    ? Icons.admin_panel_settings
                    : Icons.person,
                color: user.role == UserRole.admin
                    ? AppColors.primary
                    : AppColors.secondary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: user.role == UserRole.admin
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.displayName.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: user.role == UserRole.admin
                                    ? AppColors.primary
                                    : AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    user.department,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'Last login: ${_formatDateTime(user.lastLogin)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleUserAction(value, user),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit User'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'permissions',
                  child: Row(
                    children: [
                      Icon(Icons.security),
                      SizedBox(width: 8),
                      Text('Permissions'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'deactivate',
                  child: Row(
                    children: [
                      Icon(Icons.block),
                      SizedBox(width: 8),
                      Text('Deactivate'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _departments.length,
      itemBuilder: (context, index) {
        final department = _departments[index];
        final userCount = _users
            .where((u) => u.department == department)
            .length;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              child: Icon(Icons.business, color: AppColors.primary),
            ),
            title: Text(department),
            subtitle: Text('$userCount employees'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) => _handleDepartmentAction(value, department),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit Department'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'view_users',
                  child: Row(
                    children: [
                      Icon(Icons.people),
                      SizedBox(width: 8),
                      Text('View Users'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showAddUserDialog() {
    // Implementation for add user dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: const Text(
          'Add user functionality would be implemented here.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  void _handleUserAction(String action, UserProfile user) {
    // Implementation for user actions
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action action for ${user.name}')));
  }

  void _handleDepartmentAction(String action, String department) {
    // Implementation for department actions
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$action action for $department')));
  }
}
