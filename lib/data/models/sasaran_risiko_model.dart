class SasaranRisikoModel {
  final int id;
  final String sasaranUpr;
  final String? sasaran;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<IndikatorTargetModel> indikatorTargets;

  SasaranRisikoModel({
    required this.id,
    required this.sasaranUpr,
    this.sasaran,
    required this.createdAt,
    required this.updatedAt,
    required this.indikatorTargets,
  });

  factory SasaranRisikoModel.fromJson(Map<String, dynamic> json) {
    return SasaranRisikoModel(
      id: json['id'],
      sasaranUpr: json['sasaran_upr'] ?? '',
      sasaran: json['sasaran'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      indikatorTargets:
          (json['indikator_targets'] as List<dynamic>)
              .map((e) => IndikatorTargetModel.fromJson(e))
              .toList(),
    );
  }
}

class IndikatorTargetModel {
  final int id;
  final String idSasaranRisiko;
  final String indikatorKinerja;
  final String targetKinerja;
  final DateTime createdAt;
  final DateTime updatedAt;

  IndikatorTargetModel({
    required this.id,
    required this.idSasaranRisiko,
    required this.indikatorKinerja,
    required this.targetKinerja,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IndikatorTargetModel.fromJson(Map<String, dynamic> json) {
    return IndikatorTargetModel(
      id: json['id'],
      idSasaranRisiko: json['id_sasaran_risiko'],
      indikatorKinerja: json['indikator_kinerja'],
      targetKinerja: json['target_kinerja'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
