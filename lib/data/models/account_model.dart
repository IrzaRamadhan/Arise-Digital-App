class DashboardAccountModel {
  final List<AccountModel> accounts;
  final int currentPage;
  final int lastPage;

  DashboardAccountModel({
    required this.accounts,
    required this.currentPage,
    required this.lastPage,
  });

  factory DashboardAccountModel.fromJson(Map<String, dynamic> json) {
    return DashboardAccountModel(
      accounts:
          (json['data'] as List)
              .map((app) => AccountModel.fromJson(app))
              .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }
}

class AccountModel {
  final int id;
  final String name;
  final String username;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? dinasId;
  final String? avatar;
  final String roleId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    this.emailVerifiedAt,
    this.dinasId,
    required this.roleId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      avatar: json['avatar'],
      email: json['email'],
      emailVerifiedAt:
          json['email_verified_at'] != null
              ? DateTime.parse(json['email_verified_at'])
              : null,
      dinasId: json['dinas_id'],
      roleId: json['role_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
