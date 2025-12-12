part of 'level_kemungkinan_bloc.dart';

sealed class LevelKemungkinanState extends Equatable {
  const LevelKemungkinanState();

  @override
  List<Object> get props => [];
}

final class LevelKemungkinanInitial extends LevelKemungkinanState {}

final class LevelKemungkinanLoading extends LevelKemungkinanState {}

final class LevelKemungkinanFailed extends LevelKemungkinanState {
  final String message;
  const LevelKemungkinanFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class LevelKemungkinanLoaded extends LevelKemungkinanState {
  final List<LevelKemungkinanModel> listLevelKemungkinan;
  const LevelKemungkinanLoaded(this.listLevelKemungkinan);

  @override
  List<Object> get props => [listLevelKemungkinan];
}

final class LevelKemungkinanCreated extends LevelKemungkinanState {}

final class LevelKemungkinanUpdated extends LevelKemungkinanState {}

final class LevelKemungkinanDeleted extends LevelKemungkinanState {}
