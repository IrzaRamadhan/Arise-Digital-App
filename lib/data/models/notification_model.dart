import 'package:arise/shared/shared_method.dart';

class NotificationModel {
  final int id;
  final String title;
  final String jawaban;
  final int? roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.jawaban,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      jawaban: json['jawaban'],
      roleId: toInt(json['role_id']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
