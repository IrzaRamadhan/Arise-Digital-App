part of 'asset_lifecycle_bloc.dart';

sealed class AssetLifecycleEvent extends Equatable {
  const AssetLifecycleEvent();

  @override
  List<Object> get props => [];
}

class FetchAssetLifecycle extends AssetLifecycleEvent {
  final int id;
  const FetchAssetLifecycle({required this.id});

  @override
  List<Object> get props => [id];
}
