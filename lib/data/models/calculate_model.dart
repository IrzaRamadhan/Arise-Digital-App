class RiskCalculateModel {
  final bool success;
  final int besaranRisiko;
  final String klasifikasi;
  final String colorCode;
  final String riskClass;

  RiskCalculateModel({
    required this.success,
    required this.besaranRisiko,
    required this.klasifikasi,
    required this.colorCode,
    required this.riskClass,
  });

  factory RiskCalculateModel.fromJson(Map<String, dynamic> json) {
    return RiskCalculateModel(
      success: json['success'],
      besaranRisiko: json['besaran_risiko'],
      klasifikasi: json['klasifikasi'],
      colorCode: json['color_code'],
      riskClass: json['risk_class'],
    );
  }
}

class LikelihoodCalculateModel {
  final bool success;
  final int likelihood;

  LikelihoodCalculateModel({required this.success, required this.likelihood});

  factory LikelihoodCalculateModel.fromJson(Map<String, dynamic> json) {
    return LikelihoodCalculateModel(
      success: json['success'],
      likelihood: json['likelihood'],
    );
  }
}
