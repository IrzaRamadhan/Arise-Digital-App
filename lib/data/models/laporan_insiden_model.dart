import 'package:arise/data/models/asset_model.dart';
import 'vendor_model.dart';

class DashboardLaporanInsidenModel {
  final List<LaporanInsidenModel> pemeliharaans;
  final int currentPage;
  final int lastPage;

  DashboardLaporanInsidenModel({
    required this.pemeliharaans,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardLaporanInsidenModel.fromJson(Map<String, dynamic> json) {
    return DashboardLaporanInsidenModel(
      pemeliharaans:
          (json['data'] as List)
              .map((app) => LaporanInsidenModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class LaporanInsidenModel {
  final int id;
  final String tanggalRealisasi;
  final String jenis;
  final String biaya;
  final String catatan;
  final VendorModel vendor;
  final AssetModel asset;
  final DateTime createdAt;
  final DateTime updatedAt;

  LaporanInsidenModel({
    required this.id,
    required this.tanggalRealisasi,
    required this.jenis,
    required this.biaya,
    required this.catatan,
    required this.vendor,
    required this.asset,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LaporanInsidenModel.fromJson(Map<String, dynamic> json) {
    return LaporanInsidenModel(
      id: json['id'],
      tanggalRealisasi: json['tanggal_realisasi'],
      jenis: json['jenis'],
      biaya: json['biaya'],
      catatan: json['catatan'],
      vendor: VendorModel.fromJson(json['vendor']),
      asset: AssetModel.fromJson(json['asset']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
