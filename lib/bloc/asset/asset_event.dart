part of 'asset_bloc.dart';

sealed class AssetEvent extends Equatable {
  const AssetEvent();

  @override
  List<Object> get props => [];
}

class FetchAssetDetail extends AssetEvent {
  final int id;
  final String type;
  const FetchAssetDetail({required this.id, required this.type});

  @override
  List<Object> get props => [id];
}

class CreateAssetBarang extends AssetEvent {
  final AssetBarangFormModel data;
  final String? lampiranFile;
  const CreateAssetBarang({required this.data, required this.lampiranFile});

  @override
  List<Object> get props => [data];
}

class CreateAssetSdm extends AssetEvent {
  final AssetSdmFormModel data;
  const CreateAssetSdm({required this.data});

  @override
  List<Object> get props => [data];
}
