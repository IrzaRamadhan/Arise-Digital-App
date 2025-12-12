class SertifikatModel {
  final int id;
  final String nama;
  final String? lampiran;
  final KompetensiModel kompetensi;
  final DateTime createdAt;
  final DateTime updatedAt;

  SertifikatModel({
    required this.id,
    required this.nama,
    this.lampiran,
    required this.kompetensi,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SertifikatModel.fromJson(Map<String, dynamic> json) {
    return SertifikatModel(
      id: json['id'],
      nama: json['nama'],
      lampiran: json['lampiran'],
      kompetensi: KompetensiModel.fromJson(json['kompetensi']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class KompetensiModel {
  final int id;
  final String nama;

  KompetensiModel({required this.id, required this.nama});

  factory KompetensiModel.fromJson(Map<String, dynamic> json) {
    return KompetensiModel(id: json['id'], nama: json['nama']);
  }
}
