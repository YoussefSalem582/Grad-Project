part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserAuthenticated extends UserState {
  final UserEntity user;

  const UserAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class UserLoggedOut extends UserState {
  const UserLoggedOut();
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
