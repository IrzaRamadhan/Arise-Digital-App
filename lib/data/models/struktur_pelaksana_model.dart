class StrukturPelaksanaModel {
  final int id;
  final String nama;
  final String? jabatan;
  final String peran;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  StrukturPelaksanaModel({
    required this.id,
    required this.nama,
    this.jabatan,
    required this.peran,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StrukturPelaksanaModel.fromJson(Map<String, dynamic> json) {
    return StrukturPelaksanaModel(
      id: json['id'],
      nama: json['nama'],
      jabatan: json['jabatan'],
      peran: json['peran'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
