class DashboardSummaryModel {
  final int totalAktif;
  final int totalAktifTi;
  final int totalAktifNonTi;
  final int dueMaintenanceTotal;
  final int dueMaintenanceTi;
  final int dueMaintenanceNonTi;
  final int residualRiskTotal;
  final int residualRiskTi;
  final int residualRiskNonTi;
  final int endOfLifeTotal;
  final int endOfLifeTi;
  final int endOfLifeNonTi;

  DashboardSummaryModel({
    required this.totalAktif,
    required this.totalAktifTi,
    required this.totalAktifNonTi,
    required this.dueMaintenanceTotal,
    required this.dueMaintenanceTi,
    required this.dueMaintenanceNonTi,
    required this.residualRiskTotal,
    required this.residualRiskTi,
    required this.residualRiskNonTi,
    required this.endOfLifeTotal,
    required this.endOfLifeTi,
    required this.endOfLifeNonTi,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalAktif: json['totalAktif'],
      totalAktifTi: json['totalAktifTi'],
      totalAktifNonTi: json['totalAktifNonTi'],
      dueMaintenanceTotal: json['dueMaintenanceTotal'],
      dueMaintenanceTi: json['dueMaintenanceTi'],
      dueMaintenanceNonTi: json['dueMaintenanceNonTi'],
      residualRiskTotal: json['residualRiskTotal'],
      residualRiskTi: json['residualRiskTi'],
      residualRiskNonTi: json['residualRiskNonTi'],
      endOfLifeTotal: json['endOfLifeTotal'],
      endOfLifeTi: json['endOfLifeTi'],
      endOfLifeNonTi: json['endOfLifeNonTi'],
    );
  }
}
