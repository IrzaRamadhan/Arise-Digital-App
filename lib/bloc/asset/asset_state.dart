part of 'asset_bloc.dart';

sealed class AssetState extends Equatable {
  const AssetState();

  @override
  List<Object> get props => [];
}

final class AssetInitial extends AssetState {}

final class AssetLoading extends AssetState {}

final class AssetFailed extends AssetState {
  final String message;
  const AssetFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class AssetDetailLoaded extends AssetState {
  final AssetModel asset;
  const AssetDetailLoaded(this.asset);

  @override
  List<Object> get props => [asset];
}

final class AssetBarangCreated extends AssetState {}

final class AssetSdmCreated extends AssetState {}

final class AssetUpdated extends AssetState {}

final class AssetDeleted extends AssetState {}
