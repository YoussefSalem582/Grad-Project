enum UserRole { admin, employee }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.employee:
        return 'Employee';
    }
  }

  String get description {
    switch (this) {
      case UserRole.admin:
        return 'Full system access with management capabilities';
      case UserRole.employee:
        return 'Employee access with personal dashboard';
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String department;
  final DateTime lastLogin;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.lastLogin,
  });

  factory UserProfile.dummy(UserRole role) {
    return UserProfile(
      id: '${role.name}_user_001',
      name: role == UserRole.admin ? 'Admin User' : 'John Employee',
      email: role == UserRole.admin ? 'admin@company.com' : 'john@company.com',
      role: role,
      department: role == UserRole.admin ? 'IT Management' : 'Customer Service',
      lastLogin: DateTime.now().subtract(const Duration(hours: 2)),
    );
  }
}
