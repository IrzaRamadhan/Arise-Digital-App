import '../../../../data/models/nilai_risiko_model.dart';
import '../../components/data_text_item.dart';
import 'package:flutter/material.dart';

class NilaiRisikoCard extends StatelessWidget {
  final NilaiRisikoModel nilaiRisiko;
  const NilaiRisikoCard({super.key, required this.nilaiRisiko});

  Color _getClassificationColor() {
    final label = (nilaiRisiko.labelKlasifikasi ?? '').toLowerCase();
    if (label.contains('tinggi') || label.contains('high')) {
      return Colors.red.shade50;
    } else if (label.contains('sedang') || label.contains('medium')) {
      return Colors.orange.shade50;
    } else if (label.contains('rendah') || label.contains('low')) {
      return Colors.green.shade50;
    }
    return Colors.blue.shade50;
  }

  Color _getClassificationBorderColor() {
    final label = (nilaiRisiko.labelKlasifikasi ?? '').toLowerCase();
    if (label.contains('tinggi') || label.contains('high')) {
      return Colors.red.shade300;
    } else if (label.contains('sedang') || label.contains('medium')) {
      return Colors.orange.shade300;
    } else if (label.contains('rendah') || label.contains('low')) {
      return Colors.green.shade300;
    }
    return Colors.blue.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.assessment_outlined,
                        size: 20,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nilaiRisiko.asset.namaAsset,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1a1a1a),
                            ),
                          ),
                          if (nilaiRisiko.asset.unitKerja != null)
                            Text(
                              nilaiRisiko.asset.unitKerja!.dinas.nama,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // CONTENT
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataTextItem(
                  title: 'Kejadian',
                  widthTitle: 90,
                  value: nilaiRisiko.kejadian ?? '-',
                ),
                DataTextItem(
                  title: 'Kategori Risiko',
                  widthTitle: 90,
                  value: nilaiRisiko.kategoriRisiko.nama,
                ),
                DataTextItem(
                  title: 'Area Dampak',
                  widthTitle: 90,
                  value: nilaiRisiko.areaDampak.nama,
                ),
                DataTextItem(
                  title: 'Level Dampak',
                  widthTitle: 90,
                  value: nilaiRisiko.levelDampak.nama,
                ),
                DataTextItem(
                  title: 'Level Kemungkinan',
                  widthTitle: 90,
                  value: nilaiRisiko.levelKemungkinan.nama,
                ),

                // NILAI RISIKO BOX
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: DataTextItem(
                          title: 'Nilai Risiko',
                          widthTitle: 98,
                          value: nilaiRisiko.besaranRisiko.toString(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getClassificationColor(),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: _getClassificationBorderColor(),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          nilaiRisiko.tingkatRisikoSaatIni ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getClassificationBorderColor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
