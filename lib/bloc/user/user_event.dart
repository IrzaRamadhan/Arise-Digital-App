part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final UserFormModel data;
  final String? img;
  const UpdateUser(this.data, this.img);

  @override
  List<Object> get props => [data];
}

class LoadUser extends UserEvent {
  final UserModel user;
  const LoadUser(this.user);

  @override
  List<Object> get props => [user];
}

class LogoutUser extends UserEvent {}
