part of 'asset_sdm_bloc.dart';

sealed class AssetSdmEvent extends Equatable {
  const AssetSdmEvent();

  @override
  List<Object> get props => [];
}

class ApproveAssetSdm extends AssetSdmEvent {
  final int id;
  const ApproveAssetSdm(this.id);

  @override
  List<Object> get props => [id];
}

class RejectAssetSdm extends AssetSdmEvent {
  final int id;
  const RejectAssetSdm(this.id);

  @override
  List<Object> get props => [id];
}

class MaintenanceStartAssetSdm extends AssetSdmEvent {
  final int id;
  const MaintenanceStartAssetSdm(this.id);

  @override
  List<Object> get props => [id];
}

class MaintenanceCompleteAssetSdm extends AssetSdmEvent {
  final int id;
  const MaintenanceCompleteAssetSdm(this.id);

  @override
  List<Object> get props => [id];
}

class DecommissionProposeAssetSdm extends AssetSdmEvent {
  final int id;
  const DecommissionProposeAssetSdm(this.id);

  @override
  List<Object> get props => [id];
}

class DisposalProposeAssetSdm extends AssetSdmEvent {
  final int id;
  final String reason;
  final String method;
  const DisposalProposeAssetSdm({
    required this.id,
    required this.reason,
    required this.method,
  });

  @override
  List<Object> get props => [id];
}
