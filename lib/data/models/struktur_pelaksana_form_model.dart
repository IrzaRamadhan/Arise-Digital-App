class StrukturPelaksanaFormModel {
  final String nama;
  final String? jabatan;
  final String peran;
  final bool isActive;

  StrukturPelaksanaFormModel({
    required this.nama,
    this.jabatan,
    required this.peran,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'jabatan': jabatan,
      'peran': peran,
      'is_active': isActive,
    };
  }
}
