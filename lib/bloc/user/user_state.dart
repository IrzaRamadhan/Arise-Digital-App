part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserFailed extends UserState {
  final String message;
  const UserFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class UserLoaded extends UserState {
  final UserModel user;
  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class UserUpdated extends UserState {}
