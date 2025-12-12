import 'package:arise/shared/shared_method.dart';

import 'asset_barang_model.dart';
import 'asset_sdm_model.dart';
import 'unit_kerja_model.dart';

class DashboardAssetModel {
  final List<AssetModel> assets;
  final int currentPage;
  final int lastPage;

  DashboardAssetModel({
    required this.assets,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardAssetModel.fromJson(Map<String, dynamic> json) {
    return DashboardAssetModel(
      assets:
          (json['data'] as List)
              .map((app) => AssetModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class AssetModel {
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
  final UnitKerjaModel? unitKerja;
  final AssetBarangModel? assetBarang;
  final AssetSdmModel? assetSdm;
  final bool? pendingVerif;
  final bool? pendingNonaktif;
  final bool? pendingPenghapusan;

  AssetModel({
    required this.id,
    required this.kodeBmd,
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
    this.unitKerja,
    this.assetBarang,
    this.assetSdm,
    this.pendingVerif,
    this.pendingNonaktif,
    this.pendingPenghapusan,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) {
    return AssetModel(
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
      unitKerja:
          json['unit_kerja'] != null
              ? UnitKerjaModel.fromJson(json['unit_kerja'])
              : null,
      assetBarang:
          json['asset_barang'] != null
              ? AssetBarangModel.fromJson(json['asset_barang'])
              : null,
      assetSdm:
          json['asset_sdm'] != null
              ? AssetSdmModel.fromJson(json['asset_sdm'])
              : null,
      pendingVerif:
          json['verification_status'] != null
              ? json['verification_status']['pending_verif']
              : null,
      pendingNonaktif:
          json['verification_status'] != null
              ? json['verification_status']['pending_nonaktif']
              : null,
      pendingPenghapusan:
          json['verification_status'] != null
              ? json['verification_status']['pending_penghapusan']
              : null,
    );
  }
}
