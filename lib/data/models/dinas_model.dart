class DinasModel {
  final int id;
  final String nama;

  DinasModel({required this.id, required this.nama});

  factory DinasModel.fromJson(Map<String, dynamic> json) {
    return DinasModel(id: json['id'], nama: json['nama']);
  }
}
