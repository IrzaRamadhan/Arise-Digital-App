part of 'stakeholders_bloc.dart';

sealed class StakeholdersEvent extends Equatable {
  const StakeholdersEvent();

  @override
  List<Object> get props => [];
}

class FetchStakeholders extends StakeholdersEvent {}

class CreateStakeholders extends StakeholdersEvent {
  final StakeholdersFormModel data;
  const CreateStakeholders(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateStakeholders extends StakeholdersEvent {
  final int id;
  final StakeholdersFormModel data;
  const UpdateStakeholders({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteStakeholders extends StakeholdersEvent {
  final int id;
  const DeleteStakeholders(this.id);

  @override
  List<Object> get props => [id];
}
