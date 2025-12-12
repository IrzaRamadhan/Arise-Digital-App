part of 'matriks_risiko_bloc.dart';

sealed class MatriksRisikoEvent extends Equatable {
  const MatriksRisikoEvent();

  @override
  List<Object> get props => [];
}

class FetchMatriksRisiko extends MatriksRisikoEvent {}
