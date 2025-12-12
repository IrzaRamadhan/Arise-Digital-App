import 'package:arise/data/models/sub_kategori_model.dart';

class DashboardRekapNilai {
  final List<RekapNilaiModel> listRekapNilai;
  final int currentPage;
  final int lastPage;

  DashboardRekapNilai({
    required this.listRekapNilai,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardRekapNilai.fromJson(Map<String, dynamic> json) {
    return DashboardRekapNilai(
      listRekapNilai:
          (json['data'] as List)
              .map((app) => RekapNilaiModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class RekapNilaiModel {
  final String jumlahAsset;
  final String totalNilai;
  final String rataRataNilai;
  final SubKategoriModel? subKategori;

  RekapNilaiModel({
    required this.jumlahAsset,
    required this.totalNilai,
    required this.rataRataNilai,
    this.subKategori,
  });

  factory RekapNilaiModel.fromJson(Map<String, dynamic> json) {
    return RekapNilaiModel(
      jumlahAsset: json['jumlah_asset'],
      totalNilai: json['total_nilai'],
      rataRataNilai: json['rata_rata_nilai'],
      subKategori:
          json['sub_kategori'] != null
              ? SubKategoriModel.fromJson(json['sub_kategori'])
              : null,
    );
  }
}
