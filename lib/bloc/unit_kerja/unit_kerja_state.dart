part of 'unit_kerja_bloc.dart';

sealed class UnitKerjaState extends Equatable {
  const UnitKerjaState();

  @override
  List<Object> get props => [];
}

final class UnitKerjaInitial extends UnitKerjaState {}

final class UnitKerjaLoading extends UnitKerjaState {}

final class UnitKerjaFailed extends UnitKerjaState {
  final String message;
  const UnitKerjaFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class UnitKerjaLoaded extends UnitKerjaState {
  final List<UnitKerjaModel> listUnitKerja;
  const UnitKerjaLoaded(this.listUnitKerja);

  @override
  List<Object> get props => [listUnitKerja];
}

final class UnitKerjaCreated extends UnitKerjaState {}
