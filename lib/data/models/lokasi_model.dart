class LokasiModel {
  final int id;
  final String nama;
  final String alamat;
  final String latitude;
  final String longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  LokasiModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
