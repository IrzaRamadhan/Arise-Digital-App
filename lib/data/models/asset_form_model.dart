class AssetFormModel {
  final String kodeBmd;
  final String nomorSeri;
  final String namaAset;
  final String kategori; //ti || non-ti
  final String subKategoriId;
  final String lokasiId;
  final String penanggungjawab;
  final String dinasId;
  final String vendorId;
  final String tanggalPerolehan;
  final String periodePemeliharaan;
  final String nilaiPerolehan;
  final String kondisi;
  final String? lampiranLink;

  AssetFormModel({
    required this.kodeBmd,
    required this.nomorSeri,
    required this.namaAset,
    required this.kategori,
    required this.subKategoriId,
    required this.lokasiId,
    required this.penanggungjawab,
    required this.dinasId,
    required this.vendorId,
    required this.tanggalPerolehan,
    required this.periodePemeliharaan,
    required this.nilaiPerolehan,
    required this.kondisi,
    this.lampiranLink,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'kode_bmd': kodeBmd,
      'nomor_seri': nomorSeri,
      'nama_aset': namaAset,
      'kategori': kategori,
      'sub_kategori_id': subKategoriId,
      'lokasi_id': lokasiId,
      'penanggungjawab': penanggungjawab,
      'dinas_id': dinasId,
      'vendor_id': vendorId,
      'tanggal_perolehan': tanggalPerolehan,
      'periode_pemeliharaan': periodePemeliharaan,
      'nilai_perolehan': nilaiPerolehan,
      'kondisi': kondisi,
    };

    if (lampiranLink != null && lampiranLink != '') {
      data['lampiran_link'] = lampiranLink;
    }

    return data;
  }
}
