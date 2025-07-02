import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

/// Remote data source for user operations
abstract class UserRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> updateUser(UserModel user);
  Future<UserModel> updatePreferences(UserPreferences preferences);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getUserById(String id);
}

/// Implementation of user remote data source
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserModel?> getCurrentUser() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Return mock user
    return UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@company.com',
      role: UserRole.employee,
      avatar: null,
      createdAt: DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
      preferences: UserPreferencesModel(
        darkMode: false,
        language: 'en',
        notifications: true,
        timezone: 'UTC',
      ),
    );
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  @override
  Future<UserModel> updatePreferences(UserPreferences preferences) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: 'john.doe@company.com',
      role: UserRole.employee,
      avatar: null,
      createdAt: DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
      preferences: UserPreferencesModel(
        darkMode: preferences.darkMode,
        language: preferences.language,
        notifications: preferences.notifications,
        timezone: preferences.timezone,
      ),
    );
  }

  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    return UserModel(
      id: 'user_123',
      name: 'John Doe',
      email: email,
      role: UserRole.employee,
      avatar: null,
      createdAt: DateTime.now()
          .subtract(const Duration(days: 30))
          .toIso8601String(),
      preferences: UserPreferencesModel(
        darkMode: false,
        language: 'en',
        notifications: true,
        timezone: 'UTC',
      ),
    );
  }

  @override
  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return null;
  }
}
