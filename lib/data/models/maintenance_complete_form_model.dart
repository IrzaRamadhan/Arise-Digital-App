class MaintenanceCompleteFormModel {
  final String namaAsset;
  final String kodeBmd;
  final String nomorSeri;
  final String periodePemeliharaan;
  final String tanggalRealisasiPemeliharaan;
  final String jenisPemeliharaan;
  final int? vendorId;
  final String biayaPemeliharaan;
  final String? buktiPemeliharaan;
  final String catatanTeknisPemeliharaan;

  MaintenanceCompleteFormModel({
    required this.namaAsset,
    required this.kodeBmd,
    required this.nomorSeri,
    required this.periodePemeliharaan,
    required this.tanggalRealisasiPemeliharaan,
    required this.jenisPemeliharaan,
    required this.vendorId,
    required this.biayaPemeliharaan,
    required this.catatanTeknisPemeliharaan,
    this.buktiPemeliharaan,
  });

  Map<String, dynamic> toJson() {
    return {
      "nama_asset": namaAsset,
      "kode_bmd": kodeBmd,
      "nomor_seri": nomorSeri,
      "periode_pemeliharaan": periodePemeliharaan,
      "tanggal_realisasi_pemeliharaan": tanggalRealisasiPemeliharaan,
      "jenis_pemeliharaan": jenisPemeliharaan,
      "vendor_id": vendorId,
      "biaya_pemeliharaan": biayaPemeliharaan,
      "keterangan_pemeliharaan": catatanTeknisPemeliharaan,
    };
  }
}
