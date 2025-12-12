import '../../shared/shared_method.dart';
import 'jabatan_model.dart';
import 'sertifikat_model.dart';

class AssetSdmModel {
  final int id;
  final int assetId;
  final String nip;
  final int? jabatanId;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final JabatanModel? jabatan;
  final List<SertifikatModel> sertifikats;

  AssetSdmModel({
    required this.id,
    required this.assetId,
    required this.nip,
    this.jabatanId,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
    this.jabatan,
    required this.sertifikats,
  });

  factory AssetSdmModel.fromJson(Map<String, dynamic> json) {
    return AssetSdmModel(
      id: json['id'],
      assetId: toInt(json['asset_id'])!,
      nip: json['nip'],
      jabatanId: toInt(json['jabatan_id']),
      catatan: json['catatan'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      jabatan:
          json['jabatan'] != null
              ? JabatanModel.fromJson(json['jabatan'])
              : null,
      sertifikats:
          json['sertifikat'] != null
              ? (json['sertifikat'] as List)
                  .map((app) => SertifikatModel.fromJson(app))
                  .toList()
              : [],
    );
  }
}
