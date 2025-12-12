part of 'area_dampak_bloc.dart';

sealed class AreaDampakEvent extends Equatable {
  const AreaDampakEvent();

  @override
  List<Object> get props => [];
}

class FetchAreaDampak extends AreaDampakEvent {}

class CreateAreaDampak extends AreaDampakEvent {
  final AreaDampakFormModel data;
  const CreateAreaDampak(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateAreaDampak extends AreaDampakEvent {
  final int id;
  final AreaDampakFormModel data;
  const UpdateAreaDampak({required this.id, required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteAreaDampak extends AreaDampakEvent {
  final int id;
  const DeleteAreaDampak(this.id);

  @override
  List<Object> get props => [id];
}
