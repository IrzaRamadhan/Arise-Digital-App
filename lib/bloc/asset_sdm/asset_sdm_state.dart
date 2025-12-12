part of 'asset_sdm_bloc.dart';

sealed class AssetSdmState extends Equatable {
  const AssetSdmState();

  @override
  List<Object> get props => [];
}

final class AssetSdmInitial extends AssetSdmState {}

final class AssetSdmLoading extends AssetSdmState {}

final class AssetSdmFailed extends AssetSdmState {
  final String message;
  const AssetSdmFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class AssetSdmApproved extends AssetSdmState {}

final class AssetSdmRejected extends AssetSdmState {}

final class AssetSdmMaintenanceStarted extends AssetSdmState {}

final class AssetSdmMaintenanceCompleted extends AssetSdmState {}

final class AssetSdmDecommissionProposed extends AssetSdmState {}

final class AssetSdmDisposalProposed extends AssetSdmState {}
