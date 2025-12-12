import 'package:arise/data/models/rekap_nilai_model.dart';
import '../../../../shared/shared_method.dart';
import '../../components/data_text_item.dart';
import 'package:flutter/material.dart';

class RekapNilaiCard extends StatelessWidget {
  final RekapNilaiModel rekapNilai;
  const RekapNilaiCard({super.key, required this.rekapNilai});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    size: 20,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Text(
                        'Rekapitulasi Nilai',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        rekapNilai.subKategori?.nama ?? 'Semua Kategori',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),

          // ---------------- CONTENT ----------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              children: [
                // ---------------- ROW: Jumlah Aset + Total Nilai ----------------
                Row(
                  spacing: 8,
                  children: [
                    // ------ Jumlah Aset ------
                    Expanded(
                      child: _InfoBox(
                        color: Colors.blue.shade50,
                        borderColor: Colors.blue.shade200,
                        icon: Icons.inventory_2_outlined,
                        iconColor: Colors.blue.shade700,
                        label: "Jumlah Aset",
                        value: rekapNilai.jumlahAsset,
                      ),
                    ),

                    // ------ Total Nilai ------
                    Expanded(
                      child: _InfoBox(
                        color: Colors.green.shade50,
                        borderColor: Colors.green.shade200,
                        icon: Icons.account_balance_wallet_outlined,
                        iconColor: Colors.green.shade700,
                        label: "Total Nilai",
                        value: toRupiah(
                          int.parse(
                            rekapNilai.totalNilai.replaceAll('.00', ''),
                          ),
                        ),

                        // Anti pecah!! 🔥
                        fitted: true,
                      ),
                    ),
                  ],
                ),

                // ---------------- Rata-rata Nilai ----------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade300, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 16,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Rata-rata Nilai per Aset',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Nilai Utama
                      Text(
                        toRupiahDecimal(double.parse(rekapNilai.rataRataNilai)),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

// ---------------------------------------------------------------------
// COMPONENT: Info Box (Reusable Elegant Box)
// ---------------------------------------------------------------------
class _InfoBox extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final bool fitted;

  const _InfoBox({
    required this.color,
    required this.borderColor,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.fitted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Nilai — aman meskipun sangat panjang
          fitted
              ? FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
              )
              : Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
        ],
      ),
    );
  }
}
