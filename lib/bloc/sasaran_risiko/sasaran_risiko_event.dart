part of 'sasaran_risiko_bloc.dart';

sealed class SasaranRisikoEvent extends Equatable {
  const SasaranRisikoEvent();

  @override
  List<Object> get props => [];
}

class FetchSasaranRisiko extends SasaranRisikoEvent {}

class CreateSasaranRisiko extends SasaranRisikoEvent {
  final SasaranRisikoFormModel data;
  const CreateSasaranRisiko(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateSasaranRisiko extends SasaranRisikoEvent {
  final int id;
  final SasaranRisikoFormModel data;
  const UpdateSasaranRisiko({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteSasaranRisiko extends SasaranRisikoEvent {
  final int id;
  const DeleteSasaranRisiko(this.id);

  @override
  List<Object> get props => [id];
}
