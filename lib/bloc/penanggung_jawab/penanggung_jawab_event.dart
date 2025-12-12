part of 'penanggung_jawab_bloc.dart';

sealed class PenanggungJawabEvent extends Equatable {
  const PenanggungJawabEvent();

  @override
  List<Object> get props => [];
}

class FetchPenanggungJawab extends PenanggungJawabEvent {}
