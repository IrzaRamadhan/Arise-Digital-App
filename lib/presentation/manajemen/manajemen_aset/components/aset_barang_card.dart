import 'package:arise/data/models/asset_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/shared_method.dart';
import '../../../../shared/theme.dart';
import '../../../../widgets/badge.dart';

class AsetBarangCard extends StatelessWidget {
  final AssetModel asset;
  final VoidCallback onDetail;
  const AsetBarangCard({
    super.key,
    required this.asset,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetail,
      child: Container(
        color: Colors.white,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Image.asset('assets/images/inventaris_aset.png', width: 31),
                Expanded(
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.namaAsset,
                        style: interSmallSemibold.copyWith(color: primary1),
                      ),
                      Text(
                        asset.kategori.toUpperCase(),
                        style: interSmallRegular.copyWith(color: primary1),
                      ),
                      Text(
                        asset.tanggalPemeliharaan != null
                            ? 'Pemeliharaan : ${DateFormat('d MMMM y', 'id_ID').format(DateTime.parse(asset.tanggalPemeliharaan!))}'
                            : 'Pemeliharaan: -',
                        style: interTinyRegular.copyWith(
                          color: Color(0xFF1D1B1B).withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge1(status: asset.status),
              ],
            ),
            Row(
              children: [
                Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (asset.assetBarang!.nilaiPerolehan != null)
                      Text(
                        'Nilai : ${toRupiah(int.parse(asset.assetBarang!.nilaiPerolehan!.split('.').first))}',
                        style: interTinySemibold.copyWith(color: primary1),
                      ),
                    if (asset.assetBarang!.tanggalPerolehan != null)
                      Text(
                        DateFormat('d MMMM y', 'id_ID').format(
                          DateTime.parse(asset.assetBarang!.tanggalPerolehan!),
                        ),
                        style: interTinyRegular.copyWith(color: primary1),
                      ),
                  ],
                ),
              ],
            ),
            Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
