part of 'sub_kategori_bloc.dart';

sealed class SubKategoriState extends Equatable {
  const SubKategoriState();

  @override
  List<Object> get props => [];
}

final class SubKategoriInitial extends SubKategoriState {}

final class SubKategoriLoading extends SubKategoriState {}

final class SubKategoriFailed extends SubKategoriState {
  final String message;
  const SubKategoriFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class SubKategoriLoaded extends SubKategoriState {
  final List<SubKategoriModel> listSubKategori;
  const SubKategoriLoaded(this.listSubKategori);

  @override
  List<Object> get props => [listSubKategori];
}

final class SubKategoriCreated extends SubKategoriState {}

final class SubKategoriUpdated extends SubKategoriState {}

final class SubKategoriDeleted extends SubKategoriState {}
