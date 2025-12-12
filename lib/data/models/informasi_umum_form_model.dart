class InformasiUmumFormModel {
  final String namaUprSpbe;
  final String tugasUprSpbe;
  final String fungsiUprSpbe;
  final String periodeWaktu;

  InformasiUmumFormModel({
    required this.namaUprSpbe,
    required this.tugasUprSpbe,
    required this.fungsiUprSpbe,
    required this.periodeWaktu,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_upr_spbe': namaUprSpbe,
      'tugas_upr_spbe': tugasUprSpbe,
      'fungsi_upr_spbe': fungsiUprSpbe,
      'periode_waktu': periodeWaktu,
    };
  }
}
