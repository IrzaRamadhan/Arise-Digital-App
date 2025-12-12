import 'package:arise/data/models/asset_model.dart';
import 'vendor_model.dart';

class DashboardRiwayatPemeliharaanModel {
  final List<RiwayatPemeliharaanModel> pemeliharaans;
  final int currentPage;
  final int lastPage;

  DashboardRiwayatPemeliharaanModel({
    required this.pemeliharaans,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardRiwayatPemeliharaanModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return DashboardRiwayatPemeliharaanModel(
      pemeliharaans:
          (json['data'] as List)
              .map((app) => RiwayatPemeliharaanModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class RiwayatPemeliharaanModel {
  final int id;
  final String tanggalRealisasi;
  final String jenis;
  final String biaya;
  final String catatan;
  final VendorModel vendor;
  final AssetModel asset;

  RiwayatPemeliharaanModel({
    required this.id,
    required this.tanggalRealisasi,
    required this.jenis,
    required this.biaya,
    required this.catatan,
    required this.vendor,
    required this.asset,
  });

  factory RiwayatPemeliharaanModel.fromJson(Map<String, dynamic> json) {
    return RiwayatPemeliharaanModel(
      id: json['id'],
      tanggalRealisasi: json['tanggal_realisasi'],
      jenis: json['jenis'],
      biaya: json['biaya'],
      catatan: json['catatan'],
      vendor: VendorModel.fromJson(json['vendor']),
      asset: AssetModel.fromJson(json['asset']),
    );
  }
}
