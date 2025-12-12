part of 'asset_lifecycle_bloc.dart';

sealed class AssetLifecycleState extends Equatable {
  const AssetLifecycleState();

  @override
  List<Object> get props => [];
}

final class AssetLifecycleInitial extends AssetLifecycleState {}

final class AssetLifecycleLoading extends AssetLifecycleState {}

final class AssetLifecycleFailed extends AssetLifecycleState {
  final String message;
  const AssetLifecycleFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class AssetLifecycleLoaded extends AssetLifecycleState {
  final AssetLifecycleModel asset;
  const AssetLifecycleLoaded(this.asset);

  @override
  List<Object> get props => [asset];
}
