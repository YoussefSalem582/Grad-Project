import '../entities/user_entity.dart';

/// Repository interface for user operations
abstract class UserRepository {
  /// Get current user
  Future<UserEntity?> getCurrentUser();

  /// Update user profile
  Future<UserEntity> updateUser(UserEntity user);

  /// Update user preferences
  Future<UserEntity> updatePreferences(UserPreferences preferences);

  /// Login user
  Future<UserEntity> login(String email, String password);

  /// Logout user
  Future<void> logout();

  /// Get user by ID
  Future<UserEntity?> getUserById(String id);
}
