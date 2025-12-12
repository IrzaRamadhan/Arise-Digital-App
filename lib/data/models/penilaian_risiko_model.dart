import 'package:arise/data/models/asset_model.dart';
import 'area_dampak_model.dart';
import 'kategori_risiko_model.dart';
import 'level_dampak_model.dart';
import 'level_kemungkinan_model.dart';

class DashboardPenilaianRisikoModel {
  final List<PenilaianRisikoModel> penilaianRisikos;
  final int currentPage;
  final int lastPage;

  DashboardPenilaianRisikoModel({
    required this.penilaianRisikos,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardPenilaianRisikoModel.fromJson(Map<String, dynamic> json) {
    return DashboardPenilaianRisikoModel(
      penilaianRisikos:
          (json['data'] as List)
              .map((app) => PenilaianRisikoModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class PenilaianRisikoModel {
  final int id;
  final String? judulRisiko;
  final String? deskripsiRisiko;
  final String? jenisRisiko;
  final String? dampakRisiko;
  final String? penyebabRisiko;
  final String? sistemPengendalian;
  final String? kontrolYangAda;
  final String? opsiPenanganan;
  final String? keputusanPenanganan;
  final String? nilaiResiko;
  final String? labelKlasifikasi;
  final String? pemilikRisiko;
  final String? mitigasiRisiko;
  final String? rencanaTindakLanjut;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final KategoriRisikoModel kategoriRisiko;
  final AreaDampakModel areaDampak;
  final LevelDampakModel levelDampak;
  final LevelKemungkinanModel levelKemungkinan;
  final AssetModel asset;

  PenilaianRisikoModel({
    required this.id,
    this.judulRisiko,
    this.deskripsiRisiko,
    this.jenisRisiko,
    this.dampakRisiko,
    this.penyebabRisiko,
    this.sistemPengendalian,
    this.kontrolYangAda,
    this.opsiPenanganan,
    this.keputusanPenanganan,
    this.pemilikRisiko,
    this.mitigasiRisiko,
    this.rencanaTindakLanjut,
    this.nilaiResiko,
    this.labelKlasifikasi,
    // required this.createdAt,
    // required this.updatedAt,
    required this.kategoriRisiko,
    required this.areaDampak,
    required this.levelDampak,
    required this.levelKemungkinan,
    required this.asset,
  });

  factory PenilaianRisikoModel.fromJson(Map<String, dynamic> json) {
    return PenilaianRisikoModel(
      id: json['id'],
      judulRisiko: json['judul_risiko'],
      deskripsiRisiko: json['deskripsi_risiko'],
      jenisRisiko: json['jenis_risiko'],
      dampakRisiko: json['dampak_risiko'],
      penyebabRisiko: json['penyebab_risiko'],
      sistemPengendalian: json['sistem_pengendalian'],
      kontrolYangAda: json['kontrol_yang_ada'],
      opsiPenanganan: json['opsi_penanganan'],
      keputusanPenanganan: json['keputusan_penanganan'],
      pemilikRisiko: json['pemilik_risiko'],
      mitigasiRisiko: json['mitigasi_risiko'],
      rencanaTindakLanjut: json['rencana_tindak_lanjut'],
      nilaiResiko: json['nilai_resiko'],
      labelKlasifikasi: json['label_klasifikasi'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
      kategoriRisiko: KategoriRisikoModel.fromJson(json['kategori_risiko']),
      areaDampak: AreaDampakModel.fromJson(json['area_dampak']),
      levelDampak: LevelDampakModel.fromJson(json['level_dampak']),
      levelKemungkinan: LevelKemungkinanModel.fromJson(
        json['level_kemungkinan'],
      ),
      asset: AssetModel.fromJson(json['asset']),
    );
  }
}
