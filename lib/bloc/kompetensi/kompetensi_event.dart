part of 'kompetensi_bloc.dart';

sealed class KompetensiEvent extends Equatable {
  const KompetensiEvent();

  @override
  List<Object> get props => [];
}

class FetchKompetensi extends KompetensiEvent {}
