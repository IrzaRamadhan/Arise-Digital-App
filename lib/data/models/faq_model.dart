import 'package:arise/shared/shared_method.dart';

class FaqModel {
  final int id;
  final String pertanyaan;
  final String jawaban;
  final int? roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  FaqModel({
    required this.id,
    required this.pertanyaan,
    required this.jawaban,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      pertanyaan: json['pertanyaan'],
      jawaban: json['jawaban'],
      roleId: toInt(json['role_id']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
