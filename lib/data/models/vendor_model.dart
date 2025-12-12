class VendorModel {
  final int id;
  final String nama;
  final DateTime createdAt;
  final DateTime updatedAt;

  VendorModel({
    required this.id,
    required this.nama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      nama: json['nama'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
