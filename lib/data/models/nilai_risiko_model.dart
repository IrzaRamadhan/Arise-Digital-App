import 'area_dampak_model.dart';
import 'asset_model.dart';
import 'kategori_risiko_model.dart';
import 'level_dampak_model.dart';
import 'level_kemungkinan_model.dart';

class DashboardNilaiRisikoModel {
  final List<NilaiRisikoModel> pemeliharaans;
  final int currentPage;
  final int lastPage;

  DashboardNilaiRisikoModel({
    required this.pemeliharaans,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardNilaiRisikoModel.fromJson(Map<String, dynamic> json) {
    return DashboardNilaiRisikoModel(
      pemeliharaans:
          (json['data'] as List)
              .map((app) => NilaiRisikoModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class NilaiRisikoModel {
  final int id;
  final String? jenis;
  final String? kejadian;
  final String? penyebab;
  final String? pengendalian;
  final String? kontrolYangAda;
  final String? opsiPenanganan;
  final String? keputusanPenanganan;
  final String? pemilikRisiko;
  final String? mitigasiRisiko;
  final String? rencanaTindakLanjut;
  final String? dampakRisiko;
  final String? nilaiResiko;
  final String? labelKlasifikasi;
  final int? besaranRisiko;
  final String? tingkatRisikoSaatIni;
  final DateTime createdAt;
  final DateTime updatedAt;
  final KategoriRisikoModel kategoriRisiko;
  final AreaDampakModel areaDampak;
  final LevelDampakModel levelDampak;
  final LevelKemungkinanModel levelKemungkinan;
  final AssetModel asset;

  NilaiRisikoModel({
    required this.id,
    this.jenis,
    this.kejadian,
    this.penyebab,
    this.pengendalian,
    this.kontrolYangAda,
    this.opsiPenanganan,
    this.keputusanPenanganan,
    this.pemilikRisiko,
    this.mitigasiRisiko,
    this.rencanaTindakLanjut,
    this.dampakRisiko,
    this.nilaiResiko,
    this.labelKlasifikasi,
    this.besaranRisiko,
    this.tingkatRisikoSaatIni,
    required this.createdAt,
    required this.updatedAt,
    required this.kategoriRisiko,
    required this.areaDampak,
    required this.levelDampak,
    required this.levelKemungkinan,
    required this.asset,
  });

  factory NilaiRisikoModel.fromJson(Map<String, dynamic> json) {
    return NilaiRisikoModel(
      id: json['id'],
      jenis: json['jenis'], // dari API
      kejadian: json['kejadian'],
      penyebab: json['penyebab'],
      pengendalian: json['pengendalian'],
      kontrolYangAda: json['kontrol_yang_ada'],
      opsiPenanganan: json['opsi_penanganan'],
      keputusanPenanganan: json['keputusan_penanganan'],
      pemilikRisiko: json['pemilik_risiko'],
      mitigasiRisiko: json['mitigasi_risiko'],
      rencanaTindakLanjut: json['rencana_tindak_lanjut'],
      dampakRisiko: json['dampak_risiko'],
      nilaiResiko: json['nilai_resiko']?.toString(),
      labelKlasifikasi: json['label_klasifikasi'],
      besaranRisiko: json['besaran_risiko'],
      tingkatRisikoSaatIni: json['tingkat_risiko_saat_ini'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
