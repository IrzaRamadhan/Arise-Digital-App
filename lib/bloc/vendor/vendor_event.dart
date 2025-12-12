part of 'vendor_bloc.dart';

sealed class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object> get props => [];
}

class FetchVendor extends VendorEvent {}

class CreateVendor extends VendorEvent {
  final VendorFormModel data;
  const CreateVendor(this.data);

  @override
  List<Object> get props => [data];
}

class UpdateVendor extends VendorEvent {
  final int id;
  final VendorFormModel data;
  const UpdateVendor({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteVendor extends VendorEvent {
  final int id;
  const DeleteVendor(this.id);

  @override
  List<Object> get props => [id];
}
