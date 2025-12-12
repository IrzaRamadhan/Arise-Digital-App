part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationFailed extends NotificationState {
  final String message;
  const NotificationFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class NotificationMarkAllRead extends NotificationState {}
