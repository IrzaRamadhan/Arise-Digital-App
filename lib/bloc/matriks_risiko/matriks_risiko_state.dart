part of 'matriks_risiko_bloc.dart';

sealed class MatriksRisikoState extends Equatable {
  const MatriksRisikoState();

  @override
  List<Object> get props => [];
}

final class MatriksRisikoInitial extends MatriksRisikoState {}

final class MatriksRisikoLoading extends MatriksRisikoState {}

final class MatriksRisikoFailed extends MatriksRisikoState {
  final String message;
  const MatriksRisikoFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class MatriksRisikoLoaded extends MatriksRisikoState {
  final List<MatriksRisikoModel> data;
  const MatriksRisikoLoaded(this.data);

  @override
  List<Object> get props => [data];
}
