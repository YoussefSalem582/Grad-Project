import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user_entity.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.authenticated(UserEntity user) = _Authenticated;
  const factory UserState.unauthenticated() = _Unauthenticated;
  const factory UserState.error(String message) = _Error;
}
