class AssetSdmFormModel {
  String? namaAsset;
  String? kategori;
  int? dinasId;
  int? unitKerjaId;
  int? periodePemeliharaan;
  String? nip;
  int? jabatanId;
  String? catatan;
  List<Certificate>? certificates;
  List<RiskAssessment>? riskAssessments;

  AssetSdmFormModel({
    this.namaAsset,
    this.kategori,
    this.dinasId,
    this.unitKerjaId,
    this.periodePemeliharaan,
    this.nip,
    this.jabatanId,
    this.catatan,
    this.certificates,
    this.riskAssessments,
  });

  // Untuk JSON biasa (GET response, dll)
  Map<String, dynamic> toJson() => {
    'nama_asset': namaAsset,
    'kategori': kategori,
    'dinas_id': dinasId,
    'unit_kerja_id': unitKerjaId,
    'periode_pemeliharaan': periodePemeliharaan,
    'nip': nip,
    'jabatan_id': jabatanId,
    'catatan': catatan,
    'certificates': certificates?.map((x) => x.toJson()).toList(),
    'risk_assessments': riskAssessments?.map((x) => x.toJson()).toList(),
  };

  // ✅ TAMBAHAN: Untuk multipart form (tanpa nested arrays)
  Map<String, dynamic> toFormFields() => {
    'nama_asset': namaAsset,
    'kategori': kategori,
    'dinas_id': dinasId,
    'unit_kerja_id': unitKerjaId,
    'periode_pemeliharaan': periodePemeliharaan,
    'nip': nip,
    'jabatan_id': jabatanId,
    'catatan': catatan,
    // SKIP certificates dan risk_assessments
  };
}

class Certificate {
  int? kompetensiId;
  String? nama;
  String? lampiran; // path/base64

  Certificate({this.kompetensiId, this.nama, this.lampiran});

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    kompetensiId: json['kompetensi_id'],
    nama: json['nama'],
    lampiran: json['lampiran'],
  );

  Map<String, dynamic> toJson() => {
    'kompetensi_id': kompetensiId,
    'nama': nama,
    'lampiran': lampiran,
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
    // 'jenis': jenis,
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
