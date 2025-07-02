import 'package:flutter/foundation.dart';
import '../../domain/entities/user_entity.dart';

/// State management for user operations
class UserProvider extends ChangeNotifier {
  // State variables
  UserEntity? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  /// Set current user
  void setUser(UserEntity user) {
    _currentUser = user;
    notifyListeners();
  }

  /// Clear current user (logout)
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  /// Update loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Update user preferences
  void updatePreferences(UserPreferences preferences) {
    if (_currentUser != null) {
      _currentUser = UserEntity(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        role: _currentUser!.role,
      );
      notifyListeners();
    }
  }
}
