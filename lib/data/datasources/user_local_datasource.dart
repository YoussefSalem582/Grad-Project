import '../models/user_model.dart';

/// Local data source for user caching
abstract class UserLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearUser();
}

/// Implementation of user local data source
class UserLocalDataSourceImpl implements UserLocalDataSource {
  // Simulate local storage with static variable
  static UserModel? _cachedUser;

  @override
  Future<void> cacheUser(UserModel user) async {
    _cachedUser = user;
  }

  @override
  Future<UserModel?> getCachedUser() async {
    return _cachedUser;
  }

  @override
  Future<void> clearUser() async {
    _cachedUser = null;
  }
}
