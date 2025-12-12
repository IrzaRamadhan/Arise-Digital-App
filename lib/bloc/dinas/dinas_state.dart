part of 'dinas_bloc.dart';

sealed class DinasState extends Equatable {
  const DinasState();

  @override
  List<Object> get props => [];
}

final class DinasInitial extends DinasState {}

final class DinasLoading extends DinasState {}

final class DinasFailed extends DinasState {
  final String message;
  const DinasFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class DinasLoaded extends DinasState {
  final List<DinasModel> listDinas;
  const DinasLoaded(this.listDinas);

  @override
  List<Object> get props => [listDinas];
}
