class AreaDampakModel {
  final int id;
  final String nama;
  final String deskripsi;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AreaDampakModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AreaDampakModel.fromJson(Map<String, dynamic> json) {
    return AreaDampakModel(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
