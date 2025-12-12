part of 'lokasi_bloc.dart';

sealed class LokasiState extends Equatable {
  const LokasiState();

  @override
  List<Object> get props => [];
}

final class LokasiInitial extends LokasiState {}

final class LokasiLoading extends LokasiState {}

final class LokasiFailed extends LokasiState {
  final String message;
  const LokasiFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class LokasiLoaded extends LokasiState {
  final List<LokasiModel> listLokasi;
  const LokasiLoaded(this.listLokasi);

  @override
  List<Object> get props => [listLokasi];
}

final class LokasiCreated extends LokasiState {}

final class LokasiUpdated extends LokasiState {}

final class LokasiDeleted extends LokasiState {}
