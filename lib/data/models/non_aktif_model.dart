import '../../shared/shared_method.dart';
import 'asset_barang_model.dart';
import 'decommission_model.dart';
import 'disposal_model.dart';
import 'unit_kerja_model.dart';

class DashboardNonAktifModel {
  final List<NonAktifModel> listNonAktif;
  final int currentPage;
  final int lastPage;

  DashboardNonAktifModel({
    required this.listNonAktif,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardNonAktifModel.fromJson(Map<String, dynamic> json) {
    return DashboardNonAktifModel(
      listNonAktif:
          (json['data'] as List)
              .map((app) => NonAktifModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class NonAktifModel {
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
  final List<DecommissionModel> decommissions;
  final List<DisposalModel> disposals;

  NonAktifModel({
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
    required this.decommissions,
    required this.disposals,
  });

  factory NonAktifModel.fromJson(Map<String, dynamic> json) {
    return NonAktifModel(
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
      decommissions:
          (json['decommissions'] as List? ?? [])
              .map((app) => DecommissionModel.fromJson(app))
              .toList(),

      disposals:
          (json['disposals'] as List? ?? [])
              .map((app) => DisposalModel.fromJson(app))
              .toList(),
    );
  }
}
