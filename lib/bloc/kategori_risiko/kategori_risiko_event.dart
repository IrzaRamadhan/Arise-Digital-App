part of 'kategori_risiko_bloc.dart';

sealed class KategoriRisikoEvent extends Equatable {
  const KategoriRisikoEvent();

  @override
  List<Object> get props => [];
}

class FetchKategoriRisiko extends KategoriRisikoEvent {}

class CreateKategoriRisiko extends KategoriRisikoEvent {
  final KategoriRisikoFormModel data;
  const CreateKategoriRisiko(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateKategoriRisiko extends KategoriRisikoEvent {
  final int id;
  final KategoriRisikoFormModel data;
  const UpdateKategoriRisiko({required this.id, required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteKategoriRisiko extends KategoriRisikoEvent {
  final int id;
  const DeleteKategoriRisiko(this.id);

  @override
  List<Object> get props => [id];
}
