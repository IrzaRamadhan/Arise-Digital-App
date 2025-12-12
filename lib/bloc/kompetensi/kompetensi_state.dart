part of 'kompetensi_bloc.dart';

sealed class KompetensiState extends Equatable {
  const KompetensiState();

  @override
  List<Object> get props => [];
}

final class KompetensiInitial extends KompetensiState {}

final class KompetensiLoading extends KompetensiState {}

final class KompetensiFailed extends KompetensiState {
  final String message;
  const KompetensiFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class KompetensiLoaded extends KompetensiState {
  final List<KompetensiModel> listKompetensi;
  const KompetensiLoaded(this.listKompetensi);

  @override
  List<Object> get props => [listKompetensi];
}
