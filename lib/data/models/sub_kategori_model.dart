class SubKategoriModel {
  final int id;
  final String nama;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubKategoriModel({
    required this.id,
    required this.nama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubKategoriModel.fromJson(Map<String, dynamic> json) {
    return SubKategoriModel(
      id: json['id'],
      nama: json['nama'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
