part of 'jabatan_bloc.dart';

sealed class JabatanState extends Equatable {
  const JabatanState();

  @override
  List<Object> get props => [];
}

final class JabatanInitial extends JabatanState {}

final class JabatanLoading extends JabatanState {}

final class JabatanFailed extends JabatanState {
  final String message;
  const JabatanFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class JabatanLoaded extends JabatanState {
  final List<JabatanModel> listJabatan;
  const JabatanLoaded(this.listJabatan);

  @override
  List<Object> get props => [listJabatan];
}
