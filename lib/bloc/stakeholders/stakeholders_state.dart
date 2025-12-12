part of 'stakeholders_bloc.dart';

sealed class StakeholdersState extends Equatable {
  const StakeholdersState();

  @override
  List<Object> get props => [];
}

final class StakeholdersInitial extends StakeholdersState {}

final class StakeholdersLoading extends StakeholdersState {}

final class StakeholdersFailed extends StakeholdersState {
  final String message;
  const StakeholdersFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class StakeholdersLoaded extends StakeholdersState {
  final List<StakeholdersModel> listStakeholders;
  const StakeholdersLoaded(this.listStakeholders);

  @override
  List<Object> get props => [listStakeholders];
}

final class StakeholdersCreated extends StakeholdersState {}

final class StakeholdersUpdated extends StakeholdersState {}

final class StakeholdersDeleted extends StakeholdersState {}
