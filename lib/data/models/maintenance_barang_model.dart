import '../../shared/shared_method.dart';
import 'vendor_model.dart';

class MaintenanceBarangModel {
  final int id;
  final int assetId;
  final int? vendorId;
  final String jenis; // 'insidental', 'terjadwal'
  final String? biaya;
  final String? bukti;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VendorModel? vendor;

  MaintenanceBarangModel({
    required this.id,
    required this.assetId,
    this.vendorId,
    required this.jenis,
    this.biaya,
    this.bukti,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
    this.vendor,
  });

  factory MaintenanceBarangModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceBarangModel(
      id: json['id'],
      assetId: toInt(json['asset_id'])!,
      vendorId: json['vendor_id'],
      jenis: json['jenis'],
      biaya: json['biaya'],
      bukti: json['bukti'],
      catatan: json['catatan'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      vendor:
          json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
    );
  }
}
