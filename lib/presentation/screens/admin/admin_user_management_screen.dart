import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../widgets/common/animated_background_widget.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;
  String _searchQuery = '';
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _users = [
    {
      'id': '001',
      'name': 'Ahmed Hany',
      'email': 'ahmed.hany@company.com',
      'role': 'Employee',
      'department': 'Customer Service',
      'status': 'Active',
      'lastLogin': '2 hours ago',
      'avatar': 'A',
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': '002',
      'name': 'Ahmed Youssef',
      'email': 'ahmed.yousef@company.com',
      'role': 'Admin',
      'department': 'IT Management',
      'status': 'Active',
      'lastLogin': '30 minutes ago',
      'avatar': 'A',
      'color': const Color(0xFF2196F3),
    },
    {
      'id': '003',
      'name': 'Abdullhady Ibrahim',
      'email': 'a.ibrahim@company.com',
      'role': 'Employee',
      'department': 'Sales Support',
      'status': 'Inactive',
      'lastLogin': '2 days ago',
      'avatar': 'A',
      'color': const Color(0xFF9C27B0),
    },
    {
      'id': '004',
      'name': 'Mostafa',
      'email': 'mostafa@company.com',
      'role': 'Manager',
      'department': 'Quality Assurance',
      'status': 'Active',
      'lastLogin': '1 hour ago',
      'avatar': 'M',
      'color': const Color(0xFFFF9800),
    },
  ];

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
            child: Column(
              children: [
                SizedBox(height: customSpacing.xl * 2), // Space for admin badge
                _buildHeader(theme, customSpacing),
                SizedBox(height: customSpacing.lg),
                _buildSearchAndFilter(customSpacing),
                SizedBox(height: customSpacing.lg),
                Expanded(child: _buildUserList(customSpacing)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddUserDialog,
        backgroundColor: const Color(0xFFFF6B6B),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text(''),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, CustomSpacing customSpacing) {
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
              child: const Icon(Icons.people, color: Colors.white, size: 32),
            ),
            SizedBox(width: customSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User Management',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: customSpacing.xs),
                  Text(
                    'Manage users, roles, and permissions',
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
                          '${_users.length} users active',
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
      ),
    );
  }

  Widget _buildSearchAndFilter(CustomSpacing customSpacing) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: customSpacing.md,
                    vertical: customSpacing.md,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: customSpacing.md),
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
            child: PopupMenuButton<String>(
              initialValue: _selectedFilter,
              onSelected: (value) => setState(() => _selectedFilter = value),
              child: Container(
                padding: EdgeInsets.all(customSpacing.md),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_list, color: AppColors.primary),
                    SizedBox(width: customSpacing.xs),
                    Text(
                      _selectedFilter.toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              itemBuilder:
                  (context) => [
                    const PopupMenuItem(value: 'all', child: Text('All Users')),
                    const PopupMenuItem(
                      value: 'active',
                      child: Text('Active Only'),
                    ),
                    const PopupMenuItem(
                      value: 'inactive',
                      child: Text('Inactive Only'),
                    ),
                    const PopupMenuItem(
                      value: 'admin',
                      child: Text('Admins Only'),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(CustomSpacing customSpacing) {
    final filteredUsers =
        _users.where((user) {
          final matchesSearch =
              user['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              user['email'].toLowerCase().contains(_searchQuery.toLowerCase());

          final matchesFilter =
              _selectedFilter == 'all' ||
              (_selectedFilter == 'active' && user['status'] == 'Active') ||
              (_selectedFilter == 'inactive' && user['status'] == 'Inactive') ||
              (_selectedFilter == 'admin' && user['role'] == 'Admin');

          return matchesSearch && matchesFilter;
        }).toList();

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: customSpacing.lg),
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        final user = filteredUsers[index];
        return _buildUserCard(user, customSpacing);
      },
    );
  }

  Widget _buildUserCard(
    Map<String, dynamic> user,
    CustomSpacing customSpacing,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: customSpacing.md),
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
      child: ListTile(
        contentPadding: EdgeInsets.all(customSpacing.md),
        leading: CircleAvatar(
          backgroundColor: user['color'],
          child: Text(
            user['avatar'],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        title: Text(
          user['name'],
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: customSpacing.xs),
            Text(
              user['email'],
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            SizedBox(height: customSpacing.xs),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user['role']).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user['role'],
                    style: TextStyle(
                      color: _getRoleColor(user['role']),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: customSpacing.sm),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: customSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(
                      user['status'],
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    user['status'],
                    style: TextStyle(
                      color: _getStatusColor(user['status']),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: customSpacing.xs),
            Text(
              '${user['department']} • Last login: ${user['lastLogin']}',
              style: TextStyle(color: AppColors.textLight, fontSize: 11),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleUserAction(action, user),
          itemBuilder:
              (context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit User')),
                const PopupMenuItem(
                  value: 'reset',
                  child: Text('Reset Password'),
                ),
                const PopupMenuItem(
                  value: 'toggle',
                  child: Text('Toggle Status'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete User'),
                ),
              ],
          child: Icon(Icons.more_vert, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Admin':
        return const Color(0xFFFF6B6B);
      case 'Manager':
        return const Color(0xFF4CAF50);
      case 'Employee':
        return const Color(0xFF2196F3);
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return AppColors.success;
      case 'Inactive':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  void _handleUserAction(String action, Map<String, dynamic> user) {
    switch (action) {
      case 'edit':
        _showEditUserDialog(user);
        break;
      case 'reset':
        _showResetPasswordDialog(user);
        break;
      case 'toggle':
        _toggleUserStatus(user);
        break;
      case 'delete':
        _showDeleteUserDialog(user);
        break;
    }
  }

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New User'),
            content: const Text('Add user dialog would be implemented here'),
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

  void _showEditUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit ${user['name']}'),
            content: const Text('Edit user dialog would be implemented here'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Changes'),
              ),
            ],
          ),
    );
  }

  void _showResetPasswordDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Reset Password for ${user['name']}'),
            content: const Text(
              'Are you sure you want to reset this user\'s password?',
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
                    SnackBar(
                      content: Text('Password reset for ${user['name']}'),
                    ),
                  );
                },
                child: const Text('Reset Password'),
              ),
            ],
          ),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() {
      user['status'] = user['status'] == 'Active' ? 'Inactive' : 'Active';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user['name']} status updated to ${user['status']}'),
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete ${user['name']}'),
            content: const Text(
              'Are you sure you want to delete this user? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _users.removeWhere((u) => u['id'] == user['id']);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${user['name']} deleted')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
