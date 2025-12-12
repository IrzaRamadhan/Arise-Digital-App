import 'package:intl/intl.dart';

import '../../../../data/models/non_aktif_model.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/badge.dart';
import '../../components/data_text_item.dart';
import 'package:flutter/material.dart';

class NonAktifCard extends StatelessWidget {
  final NonAktifModel nonAktif;
  const NonAktifCard({super.key, required this.nonAktif});

  String _getAlasan() {
    if (nonAktif.decommissions.isNotEmpty &&
        nonAktif.decommissions[0].alasan != null) {
      return nonAktif.decommissions[0].alasan!;
    } else if (nonAktif.disposals.isNotEmpty &&
        nonAktif.disposals[0].alasan != null) {
      return nonAktif.disposals[0].alasan!;
    }
    return '-';
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
          // Header dengan gradient abu gelap untuk non-aktif
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
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
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.block_outlined,
                        size: 20,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            nonAktif.namaAsset,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1a1a1a),
                            ),
                          ),
                          if (nonAktif.kodeBmd != null)
                            Text(
                              nonAktif.kodeBmd!,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                                letterSpacing: 0.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                    StatusBadge4(status: nonAktif.status),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 44),
                  child: Text(
                    nonAktif.unitKerja!.dinas.nama,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey.shade200),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kategori badge
                if (nonAktif.assetBarang?.subKategori != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 14,
                          color: Colors.purple.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          nonAktif.assetBarang!.subKategori!.nama,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 4),

                // Tanggal Perolehan
                if (nonAktif.assetBarang?.tanggalPerolehan != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 2,
                          children: [
                            Text(
                              'Tanggal Perolehan',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(
                                  nonAktif.assetBarang!.tanggalPerolehan!,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1a1a1a),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Alasan Non-Aktif
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.red.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Alasan Non-Aktif',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        _getAlasan(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1a1a1a),
                          height: 1.4,
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
