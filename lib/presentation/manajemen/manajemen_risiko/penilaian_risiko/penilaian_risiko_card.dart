import 'package:arise/data/models/penilaian_risiko_model.dart';
import 'package:flutter/material.dart';

import '../../../../shared/theme.dart';
import '../../../../widgets/badge.dart';

class PenilaianRisikoCard extends StatelessWidget {
  final PenilaianRisikoModel risiko;
  const PenilaianRisikoCard({super.key, required this.risiko});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Image.asset(
                risiko.asset.jenis == 'barang'
                    ? 'assets/images/inventaris_aset.png'
                    : 'assets/images/grafis_sdm.png',
                width: 31,
              ),
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      risiko.asset.namaAsset,
                      style: interSmallSemibold.copyWith(color: primary1),
                    ),
                    Text(
                      risiko.asset.kodeBmd ?? '-',
                      style: interSmallRegular.copyWith(color: primary1),
                    ),
                  ],
                ),
              ),
              StatusBadge6(status: risiko.labelKlasifikasi ?? 'Tidak ada'),
            ],
          ),
          Divider(height: 1),
        ],
      ),
    );
  }
}
