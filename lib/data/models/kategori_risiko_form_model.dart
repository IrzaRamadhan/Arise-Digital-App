class KategoriRisikoFormModel {
  final String nama;
  final String deskripsi;
  final int seleraPositif;
  final int seleraNegatif;
  final bool isActive;

  KategoriRisikoFormModel({
    required this.nama,
    required this.deskripsi,
    required this.seleraPositif,
    required this.seleraNegatif,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'deskripsi': deskripsi,
      'selera_positif': seleraPositif,
      'selera_negatif': seleraNegatif,
      'is_active': isActive,
    };
  }
}
