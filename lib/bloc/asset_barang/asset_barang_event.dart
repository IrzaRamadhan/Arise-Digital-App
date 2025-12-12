part of 'asset_barang_bloc.dart';

sealed class AssetBarangEvent extends Equatable {
  const AssetBarangEvent();

  @override
  List<Object> get props => [];
}

class ApproveAssetBarang extends AssetBarangEvent {
  final int id;
  const ApproveAssetBarang(this.id);

  @override
  List<Object> get props => [id];
}

class RejectAssetBarang extends AssetBarangEvent {
  final int id;
  const RejectAssetBarang(this.id);

  @override
  List<Object> get props => [id];
}

class MaintenanceStartAssetBarang extends AssetBarangEvent {
  final int id;
  const MaintenanceStartAssetBarang(this.id);

  @override
  List<Object> get props => [id];
}

class MaintenanceCompleteAssetBarang extends AssetBarangEvent {
  final int id;
  final MaintenanceCompleteFormModel data;
  const MaintenanceCompleteAssetBarang({required this.id, required this.data});

  @override
  List<Object> get props => [id];
}

class DecommissionProposeAssetBarang extends AssetBarangEvent {
  final int id;
  const DecommissionProposeAssetBarang(this.id);

  @override
  List<Object> get props => [id];
}

class DisposalProposeAssetBarang extends AssetBarangEvent {
  final int id;
  final String reason;
  final String method;
  const DisposalProposeAssetBarang({
    required this.id,
    required this.reason,
    required this.method,
  });

  @override
  List<Object> get props => [id];
}
