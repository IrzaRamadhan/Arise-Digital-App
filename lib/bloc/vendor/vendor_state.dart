part of 'vendor_bloc.dart';

sealed class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object> get props => [];
}

final class VendorInitial extends VendorState {}

final class VendorLoading extends VendorState {}

final class VendorFailed extends VendorState {
  final String message;
  const VendorFailed(this.message);

  @override
  List<Object> get props => [message];
}

final class VendorLoaded extends VendorState {
  final List<VendorModel> listVendor;
  const VendorLoaded(this.listVendor);

  @override
  List<Object> get props => [listVendor];
}

final class VendorCreated extends VendorState {}

final class VendorUpdated extends VendorState {}

final class VendorDeleted extends VendorState {}
