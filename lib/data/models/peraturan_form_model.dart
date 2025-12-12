class PeraturanFormModel {
  final String nama;
  final String? amanat;

  PeraturanFormModel({required this.nama, this.amanat});

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'amanat': amanat};
  }
}
