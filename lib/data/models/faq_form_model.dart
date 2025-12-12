class FaqFormModel {
  final String pertanyaan;
  final String jawaban;
  final int roleId;

  FaqFormModel({
    required this.pertanyaan,
    required this.jawaban,
    required this.roleId,
  });

  Map<String, dynamic> toJson() {
    return {'pertanyaan': pertanyaan, 'jawaban': jawaban, 'role_id': roleId};
  }
}
