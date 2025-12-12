part of 'asset_barang_bloc.dart';

sealed class AssetBarangState extends Equatable {
  const AssetBarangState();

  @override
  List<Object> get props => [];
}

final class AssetBarangInitial extends AssetBarangState {}

final class AssetBarangLoading extends AssetBarangState {}

final class AssetBarangFailed extends AssetBarangState {
  final String message;
  const AssetBarangFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class AssetBarangApproved extends AssetBarangState {}

final class AssetBarangRejected extends AssetBarangState {}

final class AssetBarangMaintenanceStarted extends AssetBarangState {}

final class AssetBarangMaintenanceCompleted extends AssetBarangState {}

final class AssetBarangDecommissionProposed extends AssetBarangState {}

final class AssetBarangDisposalProposed extends AssetBarangState {}
