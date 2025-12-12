part of 'account_bloc.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class AccountLoading extends AccountState {}

final class AccountFailed extends AccountState {
  final String message;
  const AccountFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class AccountLoaded extends AccountState {
  final AccountModel account;
  const AccountLoaded(this.account);

  @override
  List<Object> get props => [account];
}

final class AccountCreated extends AccountState {}

final class AccountUpdated extends AccountState {}

final class AccountDeleted extends AccountState {}
