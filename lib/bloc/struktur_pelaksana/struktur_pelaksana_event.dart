part of 'struktur_pelaksana_bloc.dart';

sealed class StrukturPelaksanaEvent extends Equatable {
  const StrukturPelaksanaEvent();

  @override
  List<Object> get props => [];
}

class FetchStrukturPelaksana extends StrukturPelaksanaEvent {}

class CreateStrukturPelaksana extends StrukturPelaksanaEvent {
  final StrukturPelaksanaFormModel data;
  const CreateStrukturPelaksana(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateStrukturPelaksana extends StrukturPelaksanaEvent {
  final int id;
  final StrukturPelaksanaFormModel data;
  const UpdateStrukturPelaksana({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteStrukturPelaksana extends StrukturPelaksanaEvent {
  final int id;
  const DeleteStrukturPelaksana(this.id);

  @override
  List<Object> get props => [id];
}
