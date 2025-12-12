part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final UserModel user;
  final String? message;
  const AuthSuccess(this.user, {this.message});

  @override
  List<Object> get props => [user];
}

final class AuthFailed extends AuthState {
  final String e;
  const AuthFailed(this.e);

  @override
  List<Object> get props => [e];
}

final class AuthLogoutSuccess extends AuthState {}

final class AuthLogoutFailed extends AuthState {
  final String message;
  const AuthLogoutFailed(this.message);

  @override
  List<Object> get props => [message];
}
