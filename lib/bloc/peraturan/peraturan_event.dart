part of 'peraturan_bloc.dart';

sealed class PeraturanEvent extends Equatable {
  const PeraturanEvent();

  @override
  List<Object> get props => [];
}

class FetchPeraturan extends PeraturanEvent {}

class CreatePeraturan extends PeraturanEvent {
  final PeraturanFormModel data;
  const CreatePeraturan(this.data);

  @override
  List<Object> get props => [data];
}

class UpdatePeraturan extends PeraturanEvent {
  final int id;
  final PeraturanFormModel data;
  const UpdatePeraturan({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeletePeraturan extends PeraturanEvent {
  final int id;
  const DeletePeraturan(this.id);

  @override
  List<Object> get props => [id];
}
