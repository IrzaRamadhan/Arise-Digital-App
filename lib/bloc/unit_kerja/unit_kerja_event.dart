part of 'unit_kerja_bloc.dart';

sealed class UnitKerjaEvent extends Equatable {
  const UnitKerjaEvent();

  @override
  List<Object> get props => [];
}

class FetchUnitKerja extends UnitKerjaEvent {
  final int? dinasId;
  const FetchUnitKerja({required this.dinasId});
}
