part of 'informasi_umum_bloc.dart';

sealed class InformasiUmumEvent extends Equatable {
  const InformasiUmumEvent();

  @override
  List<Object> get props => [];
}

class FetchInformasiUmum extends InformasiUmumEvent {}

class CreateInformasiUmum extends InformasiUmumEvent {
  final InformasiUmumFormModel data;
  const CreateInformasiUmum(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateInformasiUmum extends InformasiUmumEvent {
  final int id;
  final InformasiUmumFormModel data;
  const UpdateInformasiUmum({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteInformasiUmum extends InformasiUmumEvent {
  final int id;
  const DeleteInformasiUmum(this.id);

  @override
  List<Object> get props => [id];
}
