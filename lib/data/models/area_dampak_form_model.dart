class AreaDampakFormModel {
  final String nama;
  final String deskripsi;
  final bool isActive;

  AreaDampakFormModel({
    required this.nama,
    required this.deskripsi,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'deskripsi': deskripsi, 'is_active': isActive};
  }
}
