part of 'peraturan_bloc.dart';

sealed class PeraturanState extends Equatable {
  const PeraturanState();

  @override
  List<Object> get props => [];
}

final class PeraturanInitial extends PeraturanState {}

final class PeraturanLoading extends PeraturanState {}

final class PeraturanFailed extends PeraturanState {
  final String message;
  const PeraturanFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class PeraturanLoaded extends PeraturanState {
  final List<PeraturanModel> listPeraturan;
  const PeraturanLoaded(this.listPeraturan);

  @override
  List<Object> get props => [listPeraturan];
}

final class PeraturanCreated extends PeraturanState {}

final class PeraturanUpdated extends PeraturanState {}

final class PeraturanDeleted extends PeraturanState {}
