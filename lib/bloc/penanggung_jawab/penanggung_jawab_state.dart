part of 'penanggung_jawab_bloc.dart';

sealed class PenanggungJawabState extends Equatable {
  const PenanggungJawabState();

  @override
  List<Object> get props => [];
}

final class PenanggungJawabInitial extends PenanggungJawabState {}

final class PenanggungJawabLoading extends PenanggungJawabState {}

final class PenanggungJawabFailed extends PenanggungJawabState {
  final String message;
  const PenanggungJawabFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class PenanggungJawabLoaded extends PenanggungJawabState {
  final List<PenanggungJawabModel> listPenanggungJawab;
  const PenanggungJawabLoaded(this.listPenanggungJawab);

  @override
  List<Object> get props => [listPenanggungJawab];
}
