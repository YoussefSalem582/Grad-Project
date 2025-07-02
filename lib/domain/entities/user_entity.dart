import 'package:equatable/equatable.dart';

/// Domain entity representing a user
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? profileImage;
  final DateTime? lastLogin;
  final Map<String, dynamic>? preferences;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.profileImage,
    this.lastLogin,
    this.preferences,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    role,
    profileImage,
    lastLogin,
    preferences,
  ];

  @override
  bool get stringify => true;
}

enum UserRole { admin, employee, manager }

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
