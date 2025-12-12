import 'package:arise/data/models/lokasi_model.dart';
import 'package:arise/data/models/sub_kategori_model.dart';
import 'package:arise/data/models/vendor_model.dart';
import 'package:arise/shared/shared_method.dart';

class AssetBarangModel {
  final int id;
  final int assetId;
  final int? subKategoriId;
  final int? vendorId;
  final int? lokasiId;
  final String? nilaiPerolehan;
  final String? tanggalPerolehan;
  final String kondisi; // 'baik', 'rusak-ringan', 'rusak-berat'
  final String? lampiranFile;
  final String? lampiranLink;
  final String? keterangan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final LokasiModel? lokasi;
  final VendorModel? vendor;
  final SubKategoriModel? subKategori;

  AssetBarangModel({
    required this.id,
    required this.assetId,
    this.subKategoriId,
    this.vendorId,
    this.lokasiId,
    this.nilaiPerolehan,
    this.tanggalPerolehan,
    required this.kondisi,
    this.lampiranFile,
    this.lampiranLink,
    this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    this.lokasi,
    this.vendor,
    this.subKategori,
  });

  factory AssetBarangModel.fromJson(Map<String, dynamic> json) {
    return AssetBarangModel(
      id: json['id'],
      assetId: toInt(json['asset_id'])!,
      subKategoriId: toInt(json['sub_kategori_id']),
      lokasiId: toInt(json['lokasi_id']),
      vendorId: toInt(json['vendor_id']),
      nilaiPerolehan: json['nilai_perolehan'],
      tanggalPerolehan: json['tanggal_perolehan'],
      kondisi: json['kondisi'],
      lampiranFile: json['lampiran_file'],
      lampiranLink: json['lampiran_link'],
      keterangan: json['keterangan'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lokasi:
          json['lokasi'] != null ? LokasiModel.fromJson(json['lokasi']) : null,
      vendor:
          json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
      subKategori:
          json['sub_kategori'] != null
              ? SubKategoriModel.fromJson(json['sub_kategori'])
              : null,
    );
  }
}
