part of 'sub_kategori_bloc.dart';

sealed class SubKategoriEvent extends Equatable {
  const SubKategoriEvent();

  @override
  List<Object> get props => [];
}

class FetchSubKategori extends SubKategoriEvent {}

class CreateSubKategori extends SubKategoriEvent {
  final SubKategoriFormModel data;
  const CreateSubKategori(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateSubKategori extends SubKategoriEvent {
  final int id;
  final SubKategoriFormModel data;
  const UpdateSubKategori({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteSubKategori extends SubKategoriEvent {
  final int id;
  const DeleteSubKategori(this.id);

  @override
  List<Object> get props => [id];
}
