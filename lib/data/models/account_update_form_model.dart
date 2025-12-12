class AccountUpdateFormModel {
  final String name;
  final String username;
  final String email;
  final String? password;
  final String? passwordConfirmation;
  final int roleId;
  final String status;

  AccountUpdateFormModel({
    required this.name,
    required this.username,
    required this.email,
    this.password,
    this.passwordConfirmation,
    required this.roleId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role_id': roleId,
      'status': status,
    };
  }
}
