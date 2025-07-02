import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/user_entity.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState.initial());

  void login(String email, String password) async {
    emit(const UserState.loading());
    try {
      // TODO: Implement actual login logic
      final user = UserEntity(
        id: '1',
        email: email,
        name: 'Test User',
        role: UserRole.employee,
      );
      emit(UserState.authenticated(user));
    } catch (e) {
      emit(UserState.error(e.toString()));
    }
  }

  void logout() {
    emit(const UserState.unauthenticated());
  }

  void updateProfile(UserEntity user) {
    emit(UserState.authenticated(user));
  }
}
