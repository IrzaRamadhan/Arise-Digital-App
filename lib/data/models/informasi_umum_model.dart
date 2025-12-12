class InformasiUmumModel {
  final int id;
  final String namaUprSpbe;
  final String? tugasUprSpbe;
  final String? fungsiUprSpbe;
  final String? periodeWaktu;
  final DateTime createdAt;
  final DateTime updatedAt;

  InformasiUmumModel({
    required this.id,
    required this.namaUprSpbe,
    this.tugasUprSpbe,
    this.fungsiUprSpbe,
    this.periodeWaktu,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InformasiUmumModel.fromJson(Map<String, dynamic> json) {
    return InformasiUmumModel(
      id: json['id'],
      namaUprSpbe: json['nama_upr_spbe'],
      tugasUprSpbe: json['tugas_upr_spbe'],
      fungsiUprSpbe: json['fungsi_upr_spbe'],
      periodeWaktu: json['periode_waktu'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
