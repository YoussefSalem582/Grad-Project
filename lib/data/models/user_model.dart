import '../../domain/entities/user_entity.dart';
import '../../domain/domain.dart';

class UserModel extends UserEntity {
  final String? avatar;
  final String? createdAt;
  final UserPreferencesModel? preferences;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    this.avatar,
    this.createdAt,
    this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      role: _stringToUserRole(json['role'] as String),
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] as String?,
      preferences: json['preferences'] != null
          ? UserPreferencesModel.fromJson(json['preferences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': _userRoleToString(role),
      'avatar': avatar,
      'createdAt': createdAt,
      'preferences': preferences?.toJson(),
    };
  }

  UserEntity toEntity() {
    return UserEntity(id: id, name: name, email: email, role: role);
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      role: entity.role,
    );
  }

  static UserRole _stringToUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'employee':
      default:
        return UserRole.employee;
    }
  }

  static String _userRoleToString(UserRole role) {
    switch (role) {
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

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
      darkMode: json['darkMode'] as bool,
      language: json['language'] as String,
      notifications: json['notifications'] as bool,
      timezone: json['timezone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'language': language,
      'notifications': notifications,
      'timezone': timezone,
    };
  }

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
