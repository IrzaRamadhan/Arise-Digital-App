import 'package:arise/shared/shared_values.dart';

import '../../shared/shared_method.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String username;
  final String? avatar;
  final String? alamat;
  final int? unitKerjaId;
  final int roleId;
  final String status;
  final String? dinasNama;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.avatar,
    this.alamat,
    this.unitKerjaId,
    required this.roleId,
    required this.status,
    required this.dinasNama,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      avatar:
          json['avatar'] != null ? '$baseUrl/storage/${json['avatar']}' : null,
      alamat: json['alamat'],
      unitKerjaId: toInt(json['unit_kerja_id']),
      roleId: toInt(json['role_id'])!,
      status: json['status'],
      dinasNama: json['dinas'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

// Role ID → Nama
const roles = {
  1: 'Diskominfo',
  2: 'OPD',
  3: 'Verifikator',
  4: 'Auditor',
  5: 'Admin Dinas',
};

// Nama → Role ID
const roleIds = {
  'Diskominfo': 1,
  'OPD': 2,
  'Verifikator': 3,
  'Auditor': 4,
  'Admin Dinas': 5,
};

const listRole = ['Diskominfo', 'OPD', 'Verifikator', 'Auditor', 'Admin Dinas'];
