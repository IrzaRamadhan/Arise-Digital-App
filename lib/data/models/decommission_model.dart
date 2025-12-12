import '../../shared/shared_method.dart';
import 'user_model.dart';

class DecommissionModel {
  final int id;
  final int assetId;
  final int? pengusulId;
  final int? verifikatorId;
  final String? alasan;
  final String? catatanVerif;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel? pengusul;
  final UserModel? verifikator;

  DecommissionModel({
    required this.id,
    required this.assetId,
    this.pengusulId,
    this.verifikatorId,
    this.alasan,
    this.catatanVerif,
    required this.createdAt,
    required this.updatedAt,
    this.pengusul,
    this.verifikator,
  });

  factory DecommissionModel.fromJson(Map<String, dynamic> json) {
    return DecommissionModel(
      id: json['id'],
      assetId: toInt(json['asset_id'])!,
      pengusulId: toInt(json['pengusul_id']),
      verifikatorId: toInt(json['verifikator_id']),
      alasan: json['alasan'],
      catatanVerif: json['catatan_verif'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pengusul:
          json['pengusul'] != null
              ? UserModel.fromJson(json['pengusul'])
              : null,
      verifikator:
          json['verifikator'] != null
              ? UserModel.fromJson(json['verifikator'])
              : null,
    );
  }
}
