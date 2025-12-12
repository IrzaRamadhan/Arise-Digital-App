import 'package:arise/shared/shared_method.dart';

class KategoriRisikoModel {
  final int id;
  final String nama;
  final String deskripsi;
  final int seleraPositif;
  final int seleraNegatif;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  KategoriRisikoModel({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.seleraPositif,
    required this.seleraNegatif,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KategoriRisikoModel.fromJson(Map<String, dynamic> json) {
    return KategoriRisikoModel(
      id: json['id'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      seleraPositif: toInt(json['selera_positif'])!,
      seleraNegatif: toInt(json['selera_negatif'])!,
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
