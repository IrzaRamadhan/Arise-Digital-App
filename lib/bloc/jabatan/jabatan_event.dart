part of 'jabatan_bloc.dart';

sealed class JabatanEvent extends Equatable {
  const JabatanEvent();

  @override
  List<Object> get props => [];
}

class FetchJabatan extends JabatanEvent {}
