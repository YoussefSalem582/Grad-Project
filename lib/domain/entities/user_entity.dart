import 'package:equatable/equatable.dart';

/// Domain entity representing a user
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? avatar;
  final DateTime createdAt;
  final UserPreferences preferences;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.createdAt,
    required this.preferences,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    role,
    avatar,
    createdAt,
    preferences,
  ];
}

enum UserRole { admin, employee }

class UserPreferences extends Equatable {
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

  @override
  List<Object> get props => [darkMode, language, notifications, timezone];
}
