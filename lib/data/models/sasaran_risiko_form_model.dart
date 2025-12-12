class SasaranRisikoFormModel {
  final String sasaranUpr;
  final String? sasaran;
  final List<SasaranIndikatorFormModel> indikatorTargets;

  SasaranRisikoFormModel({
    required this.sasaranUpr,
    this.sasaran,
    required this.indikatorTargets,
  });

  Map<String, dynamic> toJson() {
    return {
      'sasaran_upr': sasaranUpr,
      'sasaran': sasaran,
      'indikator_targets': indikatorTargets.map((e) => e.toJson()).toList(),
    };
  }
}

class SasaranIndikatorFormModel {
  final String indikatorKinerja;
  final String targetKinerja;

  SasaranIndikatorFormModel({
    required this.indikatorKinerja,
    required this.targetKinerja,
  });

  Map<String, dynamic> toJson() {
    return {
      'indikator_kinerja': indikatorKinerja,
      'target_kinerja': targetKinerja,
    };
  }
}
