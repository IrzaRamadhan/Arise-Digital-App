import 'package:arise/shared/shared_method.dart';

class PenanggungJawabModel {
  final int id;
  final String name;
  final int dinasId;

  PenanggungJawabModel({
    required this.id,
    required this.name,
    required this.dinasId,
  });

  factory PenanggungJawabModel.fromJson(Map<String, dynamic> json) {
    return PenanggungJawabModel(
      id: json['id'],
      name: json['name'],
      dinasId: toInt(json['unit_kerja']['dinas_id'])!,
    );
  }
}
