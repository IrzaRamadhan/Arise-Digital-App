class MatriksRisikoModel {
  final int levelKemungkinanId;
  final int levelDampakId;
  final String besaran;
  final String klasifikasi;
  final String riskClass;

  MatriksRisikoModel({
    required this.levelKemungkinanId,
    required this.levelDampakId,
    required this.besaran,
    required this.klasifikasi,
    required this.riskClass,
  });

  factory MatriksRisikoModel.fromJson(Map<String, dynamic> json) {
    return MatriksRisikoModel(
      levelKemungkinanId: json['level_kemungkinan_id'],
      levelDampakId: json['level_dampak_id'],
      besaran: json['besaran'].toString(),
      klasifikasi: json['klasifikasi'],
      riskClass: json['risk_class'],
    );
  }
}
