class AccountCreateFormModel {
  final String name;
  final String username;
  final String email;
  final String password;
  final int roleId;
  final int? dinasId;

  AccountCreateFormModel({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.roleId,
    required this.dinasId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'role_id': roleId,
      'dinas_id': dinasId,
    };
  }
}
