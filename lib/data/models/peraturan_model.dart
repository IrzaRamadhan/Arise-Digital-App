class PeraturanModel {
  final int id;
  final String nama;
  final String? amanat;
  final DateTime createdAt;
  final DateTime updatedAt;

  PeraturanModel({
    required this.id,
    required this.nama,
    this.amanat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PeraturanModel.fromJson(Map<String, dynamic> json) {
    return PeraturanModel(
      id: json['id'],
      nama: json['nama'],
      amanat: json['amanat'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
