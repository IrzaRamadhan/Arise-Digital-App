class StakeholdersModel {
  final int id;
  final String? unitOrganisasi;
  final String? email;
  final String? telepon;
  final String? tanggungJawab;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  StakeholdersModel({
    required this.id,
    this.unitOrganisasi,
    this.email,
    this.telepon,
    this.tanggungJawab,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StakeholdersModel.fromJson(Map<String, dynamic> json) {
    return StakeholdersModel(
      id: json['id'],
      unitOrganisasi: json['unit_organisasi'],
      email: json['email'],
      telepon: json['telepon'],
      tanggungJawab: json['tanggung_jawab'],
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
