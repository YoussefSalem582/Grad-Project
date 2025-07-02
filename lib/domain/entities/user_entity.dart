import '../domain.dart';

/// Domain entity representing a user
class UserEntity {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ role.hashCode;
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, role: $role)';
  }
}

enum UserRole { employee }

class UserPreferences {
  final bool darkMode;
  final String language;
  final bool notifications;
  final String timezone;

  const UserPreferences({
    this.darkMode = false,
    this.language = 'en',
    this.notifications = true,
    this.timezone = 'UTC',
  });
}
