enum UserRole { employee }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.employee:
        return 'Employee';
    }
  }

  String get description {
    switch (this) {
      case UserRole.employee:
        return 'Customer interaction and analysis tools';
    }
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String department;
  final UserRole role;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
  });

  factory UserProfile.dummy(UserRole role) {
    return UserProfile(
      id: '1',
      name: 'John Employee',
      email: 'john@company.com',
      role: role,
      department: 'Customer Service',
    );
  }
}
