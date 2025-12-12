part of 'sasaran_risiko_bloc.dart';

sealed class SasaranRisikoState extends Equatable {
  const SasaranRisikoState();

  @override
  List<Object> get props => [];
}

final class SasaranRisikoInitial extends SasaranRisikoState {}

final class SasaranRisikoLoading extends SasaranRisikoState {}

final class SasaranRisikoFailed extends SasaranRisikoState {
  final String message;
  const SasaranRisikoFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class SasaranRisikoLoaded extends SasaranRisikoState {
  final List<SasaranRisikoModel> listSasaranRisiko;
  const SasaranRisikoLoaded(this.listSasaranRisiko);

  @override
  List<Object> get props => [listSasaranRisiko];
}

final class SasaranRisikoCreated extends SasaranRisikoState {}

final class SasaranRisikoUpdated extends SasaranRisikoState {}

final class SasaranRisikoDeleted extends SasaranRisikoState {}
