class LevelKemungkinanFormModel {
  final String nama;
  final String deskripsi;
  final int nilai;
  final bool isActive;

  LevelKemungkinanFormModel({
    required this.nama,
    required this.deskripsi,
    required this.nilai,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'nilai': nilai,
      'is_active': isActive,
    };
  }
}
