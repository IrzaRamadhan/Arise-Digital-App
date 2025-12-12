class KompetensiModel {
  final int id;
  final String nama;
  final DateTime createdAt;
  final DateTime updatedAt;

  KompetensiModel({
    required this.id,
    required this.nama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KompetensiModel.fromJson(Map<String, dynamic> json) {
    return KompetensiModel(
      id: json['id'],
      nama: json['nama'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
