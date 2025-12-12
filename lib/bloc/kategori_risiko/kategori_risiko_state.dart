part of 'kategori_risiko_bloc.dart';

sealed class KategoriRisikoState extends Equatable {
  const KategoriRisikoState();

  @override
  List<Object> get props => [];
}

final class KategoriRisikoInitial extends KategoriRisikoState {}

final class KategoriRisikoLoading extends KategoriRisikoState {}

final class KategoriRisikoFailed extends KategoriRisikoState {
  final String message;
  const KategoriRisikoFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class KategoriRisikoLoaded extends KategoriRisikoState {
  final List<KategoriRisikoModel> listKategoriRisiko;
  const KategoriRisikoLoaded(this.listKategoriRisiko);

  @override
  List<Object> get props => [listKategoriRisiko];
}

final class KategoriRisikoCreated extends KategoriRisikoState {}

final class KategoriRisikoUpdated extends KategoriRisikoState {}

final class KategoriRisikoDeleted extends KategoriRisikoState {}
