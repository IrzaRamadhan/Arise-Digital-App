part of 'level_dampak_bloc.dart';

sealed class LevelDampakEvent extends Equatable {
  const LevelDampakEvent();

  @override
  List<Object> get props => [];
}

class FetchLevelDampak extends LevelDampakEvent {}

class CreateLevelDampak extends LevelDampakEvent {
  final LevelDampakFormModel data;
  const CreateLevelDampak(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateLevelDampak extends LevelDampakEvent {
  final int id;
  final LevelDampakFormModel data;
  const UpdateLevelDampak({required this.id, required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteLevelDampak extends LevelDampakEvent {
  final int id;
  const DeleteLevelDampak(this.id);

  @override
  List<Object> get props => [id];
}
