class AssetBarangFormModel {
  String? namaAsset;
  String? kodeBmd;
  String? nomorSeri;
  String? kategori;
  int? subKategoriId;
  int? lokasiId;
  int? penanggungJawab;
  String? penanggungJawabManual;
  int? dinasId;
  int? unitKerjaId;
  int? vendorId;
  String? periodePemeliharaan;
  String? nilaiPerolehan;
  String? tanggalPerolehan;
  String? lampiranLink;
  String? keterangan;
  List<RiskAssessment>? riskAssessments;

  AssetBarangFormModel({
    this.namaAsset,
    this.kodeBmd,
    this.nomorSeri,
    this.kategori,
    this.subKategoriId,
    this.lokasiId,
    this.penanggungJawab,
    this.penanggungJawabManual,
    this.dinasId,
    this.unitKerjaId,
    this.vendorId,
    this.periodePemeliharaan,
    this.nilaiPerolehan,
    this.tanggalPerolehan,
    this.lampiranLink,
    this.keterangan,
    this.riskAssessments,
  });

  Map<String, dynamic> toJson() => {
    'nama_asset': namaAsset,
    'kode_bmd': kodeBmd,
    'nomor_seri': nomorSeri,
    'kategori': kategori,
    'sub_kategori_id': subKategoriId,
    'lokasi_id': lokasiId,
    'penanggung_jawab': penanggungJawab,
    'penanggung_jawab_manual': penanggungJawabManual,
    'dinas_id': dinasId,
    'unit_kerja_id': unitKerjaId,
    'vendor_id': vendorId,
    'periode_pemeliharaan': periodePemeliharaan,
    'nilai_perolehan': nilaiPerolehan,
    'tanggal_perolehan': tanggalPerolehan,
    'lampiran_link': lampiranLink,
    'keterangan': keterangan,
    'risk_assessments': riskAssessments?.map((x) => x.toJson()).toList(),
  };
}

class RiskAssessment {
  String? jenis;
  int? kategoriRisikoId;
  String? kejadian;
  String? penyebab;
  int? areaDampakId;
  int? levelDampakId;
  int? levelKemungkinanId;
  int? besaran;
  String? klasifikasi;

  RiskAssessment({
    this.jenis,
    this.kategoriRisikoId,
    this.kejadian,
    this.penyebab,
    this.areaDampakId,
    this.levelDampakId,
    this.levelKemungkinanId,
    this.besaran,
    this.klasifikasi,
  });

  factory RiskAssessment.fromJson(Map<String, dynamic> json) => RiskAssessment(
    jenis: json['jenis'],
    kategoriRisikoId: json['kategori_risiko_id'],
    kejadian: json['kejadian'],
    penyebab: json['penyebab'],
    areaDampakId: json['area_dampak_id'],
    levelDampakId: json['level_dampak_id'],
    levelKemungkinanId: json['level_kemungkinan_id'],
    besaran: json['besaran'],
    klasifikasi: json['klasifikasi'],
  );

  Map<String, dynamic> toJson() => {
    'jenis': jenis,
    'kategori_risiko_id': kategoriRisikoId,
    'kejadian': kejadian,
    'penyebab': penyebab,
    'area_dampak_id': areaDampakId,
    'level_dampak_id': levelDampakId,
    'level_kemungkinan_id': levelKemungkinanId,
    'besaran': besaran,
    'klasifikasi': klasifikasi,
  };
}
