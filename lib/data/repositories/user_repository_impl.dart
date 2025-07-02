import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/network/network_info.dart';
import '../../core/errors/failures.dart';
import '../datasources/user_remote_datasource.dart';
import '../datasources/user_local_datasource.dart';
import '../models/user_model.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Try to get cached user first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return cachedUser.toEntity();
      }

      // If no cached user and we have internet, try to get from remote
      if (await networkInfo.isConnected) {
        final remoteUser = await remoteDataSource.getCurrentUser();
        if (remoteUser != null) {
          await localDataSource.cacheUser(remoteUser);
          return remoteUser.toEntity();
        }
      }

      return null;
    } catch (e) {
      throw ServerFailure('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);

      if (await networkInfo.isConnected) {
        final updatedUser = await remoteDataSource.updateUser(userModel);
        await localDataSource.cacheUser(updatedUser);
        return updatedUser.toEntity();
      } else {
        throw NetworkFailure('No internet connection');
      }
    } catch (e) {
      throw ServerFailure('Failed to update user: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> updatePreferences(UserPreferences preferences) async {
    try {
      if (await networkInfo.isConnected) {
        final updatedUser = await remoteDataSource.updatePreferences(
          preferences,
        );
        await localDataSource.cacheUser(updatedUser);
        return updatedUser.toEntity();
      } else {
        throw NetworkFailure('No internet connection');
      }
    } catch (e) {
      throw ServerFailure('Failed to update preferences: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(user);
        return user.toEntity();
      } else {
        throw NetworkFailure('No internet connection');
      }
    } catch (e) {
      throw AuthFailure('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.clearUser();

      if (await networkInfo.isConnected) {
        await remoteDataSource.logout();
      }
    } catch (e) {
      throw ServerFailure('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getUserById(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final user = await remoteDataSource.getUserById(id);
        return user?.toEntity();
      } else {
        throw NetworkFailure('No internet connection');
      }
    } catch (e) {
      throw ServerFailure('Failed to get user: ${e.toString()}');
    }
  }
}
