import 'package:arise/data/models/dinas_model.dart';
import 'package:arise/shared/shared_method.dart';

class UnitKerjaModel {
  final int id;
  final int dinasId;
  final String nama;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DinasModel dinas;

  UnitKerjaModel({
    required this.id,
    required this.dinasId,
    required this.nama,
    required this.createdAt,
    required this.updatedAt,
    required this.dinas,
  });

  factory UnitKerjaModel.fromJson(Map<String, dynamic> json) {
    return UnitKerjaModel(
      id: json['id'],
      dinasId: toInt(json['dinas_id'])!,
      nama: json['nama'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      dinas: DinasModel.fromJson(json['dinas']),
    );
  }
}
