class UserFormModel {
  final String name;
  final String email;
  final String username;

  UserFormModel({
    required this.name,
    required this.email,
    required this.username,
  });

  factory UserFormModel.fromJson(Map<String, dynamic> json) {
    return UserFormModel(
      name: json['name'],
      email: json['email'],
      username: json['username'],
    );
  }

  Map<String, String> toJson() {
    return {"name": name, "email": email, "username": username};
  }
}
