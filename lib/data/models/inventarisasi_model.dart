import 'package:arise/shared/shared_method.dart';

import 'asset_barang_model.dart';
import 'unit_kerja_model.dart';

class DashboardInventarisasi {
  final List<InventarisasiModel> listInventarisasi;
  final int currentPage;
  final int lastPage;

  DashboardInventarisasi({
    required this.listInventarisasi,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardInventarisasi.fromJson(Map<String, dynamic> json) {
    return DashboardInventarisasi(
      listInventarisasi:
          (json['data'] as List)
              .map((app) => InventarisasiModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class InventarisasiModel {
  final int id;
  final String? kodeBmd;
  final String? nomorSeri;
  final String namaAsset;
  final String? penanggungJawab;
  final String kategori; // 'ti', 'non-ti'
  final String jenis; // 'barang', 'sdm'
  final String? tanggalPemeliharaan;
  final int? periodePemeliharaan;
  final String
  status; // 'pending', 'ditolak', 'aktif', 'pemeliharaan', 'non_aktif', 'dihapus'
  final String createdAt;
  final String updatedAt;
  final UnitKerjaModel unitKerja;
  final AssetBarangModel assetBarang;

  InventarisasiModel({
    required this.id,
    this.kodeBmd,
    this.nomorSeri,
    required this.namaAsset,
    this.penanggungJawab,
    required this.kategori,
    required this.jenis,
    this.tanggalPemeliharaan,
    this.periodePemeliharaan,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.unitKerja,
    required this.assetBarang,
  });

  factory InventarisasiModel.fromJson(Map<String, dynamic> json) {
    return InventarisasiModel(
      id: json['id'],
      kodeBmd: json['kode_bmd'],
      nomorSeri: json['nomor_seri'],
      namaAsset: json['nama_asset'],
      penanggungJawab: json['penanggung_jawab'],
      kategori: json['kategori'],
      jenis: json['jenis'],
      tanggalPemeliharaan: json['tanggal_pemeliharaan'],
      periodePemeliharaan: toInt(json['periode_pemeliharaan']),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      unitKerja: UnitKerjaModel.fromJson(json['unit_kerja']),
      assetBarang: AssetBarangModel.fromJson(json['asset_barang']),
    );
  }
}
