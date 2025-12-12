class JabatanModel {
  final int id;
  final String nama;
  final DateTime createdAt;
  final DateTime updatedAt;

  JabatanModel({
    required this.id,
    required this.nama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JabatanModel.fromJson(Map<String, dynamic> json) {
    return JabatanModel(
      id: json['id'],
      nama: json['nama'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
