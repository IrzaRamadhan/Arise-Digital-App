class LokasiFormModel {
  final String nama;
  final String alamat;
  final double latitude;
  final double longitude;

  LokasiFormModel({
    required this.nama,
    required this.alamat,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "nama": nama,
      "alamat": alamat,
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
