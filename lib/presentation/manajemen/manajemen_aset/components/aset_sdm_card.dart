import 'package:arise/data/models/asset_model.dart';
import 'package:flutter/material.dart';

import '../../../../shared/theme.dart';
import '../../../../widgets/badge.dart';

class AsetSdmCard extends StatelessWidget {
  final AssetModel asset;
  final VoidCallback onDetail;
  const AsetSdmCard({super.key, required this.asset, required this.onDetail});

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
                        'NIP : ${asset.assetSdm!.nip}',
                        style: interTinyRegular.copyWith(
                          color: Color(0xFF1D1B1B).withValues(alpha: 0.5),
                        ),
                      ),
                      Text(
                        'Jabatan : ${asset.assetSdm!.jabatan}',
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

            Divider(height: 1),
          ],
        ),
      ),
    );
  }
}
