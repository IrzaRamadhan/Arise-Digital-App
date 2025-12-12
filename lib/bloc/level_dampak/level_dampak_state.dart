part of 'level_dampak_bloc.dart';

sealed class LevelDampakState extends Equatable {
  const LevelDampakState();

  @override
  List<Object> get props => [];
}

final class LevelDampakInitial extends LevelDampakState {}

final class LevelDampakLoading extends LevelDampakState {}

final class LevelDampakFailed extends LevelDampakState {
  final String message;
  const LevelDampakFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class LevelDampakLoaded extends LevelDampakState {
  final List<LevelDampakModel> listLevelDampak;
  const LevelDampakLoaded(this.listLevelDampak);

  @override
  List<Object> get props => [listLevelDampak];
}

final class LevelDampakCreated extends LevelDampakState {}

final class LevelDampakUpdated extends LevelDampakState {}

final class LevelDampakDeleted extends LevelDampakState {}
