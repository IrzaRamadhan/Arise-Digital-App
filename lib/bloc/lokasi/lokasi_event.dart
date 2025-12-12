part of 'lokasi_bloc.dart';

sealed class LokasiEvent extends Equatable {
  const LokasiEvent();

  @override
  List<Object> get props => [];
}

class FetchLokasi extends LokasiEvent {}

class CreateLokasi extends LokasiEvent {
  final LokasiFormModel data;
  const CreateLokasi(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateLokasi extends LokasiEvent {
  final int id;
  final LokasiFormModel data;
  const UpdateLokasi({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteLokasi extends LokasiEvent {
  final int id;
  const DeleteLokasi(this.id);

  @override
  List<Object> get props => [id];
}
