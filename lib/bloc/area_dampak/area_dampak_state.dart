part of 'area_dampak_bloc.dart';

sealed class AreaDampakState extends Equatable {
  const AreaDampakState();

  @override
  List<Object> get props => [];
}

final class AreaDampakInitial extends AreaDampakState {}

final class AreaDampakLoading extends AreaDampakState {}

final class AreaDampakFailed extends AreaDampakState {
  final String message;
  const AreaDampakFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class AreaDampakLoaded extends AreaDampakState {
  final List<AreaDampakModel> listAreaDampak;
  const AreaDampakLoaded(this.listAreaDampak);

  @override
  List<Object> get props => [listAreaDampak];
}

final class AreaDampakCreated extends AreaDampakState {}

final class AreaDampakUpdated extends AreaDampakState {}

final class AreaDampakDeleted extends AreaDampakState {}
