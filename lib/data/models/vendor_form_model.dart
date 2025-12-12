class VendorFormModel {
  final String nama;

  VendorFormModel({required this.nama});

  Map<String, dynamic> toJson() {
    return {'nama': nama};
  }
}
