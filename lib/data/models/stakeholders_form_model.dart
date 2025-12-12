class StakeholdersFormModel {
  final String? unitOrganisasi;
  final String? email;
  final String? telepon;
  final String? tanggungJawab;
  final bool isActive;

  StakeholdersFormModel({
    this.unitOrganisasi,
    this.email,
    this.telepon,
    this.tanggungJawab,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'unit_organisasi': unitOrganisasi,
      'email': email,
      'telepon': telepon,
      'tanggung_jawab': tanggungJawab,
      'is_active': isActive,
    };
  }
}
