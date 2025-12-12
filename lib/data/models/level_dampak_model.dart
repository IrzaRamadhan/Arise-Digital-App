import '../../shared/shared_method.dart';

class LevelDampakModel {
  final int id;
  final String nama;
  final String deskripsi;
  final int nilai;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  LevelDampakModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.nilai,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LevelDampakModel.fromJson(Map<String, dynamic> json) {
    return LevelDampakModel(
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
