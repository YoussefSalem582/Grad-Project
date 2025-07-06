import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_state.dart';

/// Cubit for managing user state and operations
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserInitial());

  /// Set current user (login)
  void setUser(UserEntity user) {
    emit(UserAuthenticated(user));
  }

  /// Clear current user (logout)
  void clearUser() {
    emit(const UserLoggedOut());
  }

  /// Update loading state
  void setLoading() {
    emit(const UserLoading());
  }

  /// Set error message
  void setError(String error) {
    emit(UserError(error));
  }

  /// Clear error message
  void clearError() {
    if (state is UserError) {
      emit(const UserInitial());
    }
  }

  /// Update user preferences
  void updatePreferences(UserPreferences preferences) {
    if (state is UserAuthenticated) {
      final currentState = state as UserAuthenticated;
      final updatedUser = UserEntity(
        id: currentState.user.id,
        name: currentState.user.name,
        email: currentState.user.email,
        role: currentState.user.role,
        avatar: currentState.user.avatar,
        createdAt: currentState.user.createdAt,
        preferences: preferences,
      );
      emit(UserAuthenticated(updatedUser));
    }
  }

  /// Get current user if authenticated
  UserEntity? get currentUser {
    if (state is UserAuthenticated) {
      return (state as UserAuthenticated).user;
    }
    return null;
  }

  /// Check if user is logged in
  bool get isLoggedIn => state is UserAuthenticated;

  /// Check if loading
  bool get isLoading => state is UserLoading;
}
