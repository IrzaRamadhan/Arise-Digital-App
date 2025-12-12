class SubKategoriFormModel {
  final String nama;

  SubKategoriFormModel({required this.nama});

  Map<String, dynamic> toJson() {
    return {'nama': nama};
  }
}
