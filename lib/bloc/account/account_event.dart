part of 'account_bloc.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class FetchAccount extends AccountEvent {
  final int id;
  const FetchAccount({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateAccount extends AccountEvent {
  final AccountCreateFormModel data;
  const CreateAccount(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateAccount extends AccountEvent {
  final int id;
  final AccountUpdateFormModel data;
  const UpdateAccount({required this.id, required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteAccount extends AccountEvent {
  final int id;
  const DeleteAccount(this.id);

  @override
  List<Object> get props => [id];
}
