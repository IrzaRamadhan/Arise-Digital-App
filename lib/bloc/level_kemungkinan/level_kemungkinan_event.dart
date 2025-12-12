part of 'level_kemungkinan_bloc.dart';

sealed class LevelKemungkinanEvent extends Equatable {
  const LevelKemungkinanEvent();

  @override
  List<Object> get props => [];
}

class FetchLevelKemungkinan extends LevelKemungkinanEvent {}

class CreateLevelKemungkinan extends LevelKemungkinanEvent {
  final LevelKemungkinanFormModel data;
  const CreateLevelKemungkinan(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateLevelKemungkinan extends LevelKemungkinanEvent {
  final int id;
  final LevelKemungkinanFormModel data;
  const UpdateLevelKemungkinan({required this.id, required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteLevelKemungkinan extends LevelKemungkinanEvent {
  final int id;
  const DeleteLevelKemungkinan(this.id);

  @override
  List<Object> get props => [id];
}
