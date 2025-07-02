import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final String createdAt;
  final UserPreferencesModel preferences;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.createdAt,
    required this.preferences,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      role: _stringToUserRole(role),
      avatar: avatar,
      createdAt: DateTime.parse(createdAt),
      preferences: preferences.toEntity(),
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: _userRoleToString(entity.role),
      avatar: entity.avatar,
      createdAt: entity.createdAt.toIso8601String(),
      preferences: UserPreferencesModel.fromEntity(entity.preferences),
    );
  }

  static UserRole _stringToUserRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'employee':
        return UserRole.employee;
      default:
        return UserRole.employee;
    }
  }

  static String _userRoleToString(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'admin';
      case UserRole.employee:
        return 'employee';
    }
  }
}

class UserPreferencesModel {
  final bool darkMode;
  final String language;
  final bool notifications;
  final String timezone;

  UserPreferencesModel({
    required this.darkMode,
    required this.language,
    required this.notifications,
    required this.timezone,
  });

  UserPreferences toEntity() {
    return UserPreferences(
      darkMode: darkMode,
      language: language,
      notifications: notifications,
      timezone: timezone,
    );
  }

  factory UserPreferencesModel.fromEntity(UserPreferences entity) {
    return UserPreferencesModel(
      darkMode: entity.darkMode,
      language: entity.language,
      notifications: entity.notifications,
      timezone: entity.timezone,
    );
  }
}
