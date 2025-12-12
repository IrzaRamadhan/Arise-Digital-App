import 'package:arise/shared/shared_method.dart';

class LevelKemungkinanModel {
  final int id;
  final String nama;
  final String deskripsi;
  final int nilai;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  LevelKemungkinanModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.nilai,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LevelKemungkinanModel.fromJson(Map<String, dynamic> json) {
    return LevelKemungkinanModel(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      nilai: toInt(json['nilai'])!,
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
