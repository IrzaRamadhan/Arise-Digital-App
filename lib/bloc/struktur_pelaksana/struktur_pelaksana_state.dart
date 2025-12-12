part of 'struktur_pelaksana_bloc.dart';

sealed class StrukturPelaksanaState extends Equatable {
  const StrukturPelaksanaState();

  @override
  List<Object> get props => [];
}

final class StrukturPelaksanaInitial extends StrukturPelaksanaState {}

final class StrukturPelaksanaLoading extends StrukturPelaksanaState {}

final class StrukturPelaksanaFailed extends StrukturPelaksanaState {
  final String message;
  const StrukturPelaksanaFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class StrukturPelaksanaLoaded extends StrukturPelaksanaState {
  final List<StrukturPelaksanaModel> listStrukturPelaksana;
  const StrukturPelaksanaLoaded(this.listStrukturPelaksana);

  @override
  List<Object> get props => [listStrukturPelaksana];
}

final class StrukturPelaksanaCreated extends StrukturPelaksanaState {}

final class StrukturPelaksanaUpdated extends StrukturPelaksanaState {}

final class StrukturPelaksanaDeleted extends StrukturPelaksanaState {}
