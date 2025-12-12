part of 'informasi_umum_bloc.dart';

sealed class InformasiUmumState extends Equatable {
  const InformasiUmumState();

  @override
  List<Object> get props => [];
}

final class InformasiUmumInitial extends InformasiUmumState {}

final class InformasiUmumLoading extends InformasiUmumState {}

final class InformasiUmumFailed extends InformasiUmumState {
  final String message;
  const InformasiUmumFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class InformasiUmumLoaded extends InformasiUmumState {
  final List<InformasiUmumModel> listInformasiUmum;
  const InformasiUmumLoaded(this.listInformasiUmum);

  @override
  List<Object> get props => [listInformasiUmum];
}

final class InformasiUmumCreated extends InformasiUmumState {}

final class InformasiUmumUpdated extends InformasiUmumState {}

final class InformasiUmumDeleted extends InformasiUmumState {}
