import 'package:flutter/material.dart';

import '../../../../helper/file_helper.dart';
import '../../../../shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailLinkItem extends StatelessWidget {
  final String title;
  final String? url;
  const DetailLinkItem({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: interBodySmallSemibold.copyWith(color: Color(0xFF2B2B2B)),
        ),
        url != null
            ? GestureDetector(
              onTap: () async {
                if (url!.contains('storage')) {
                  FileHelper.openPdf(context, url!, title);
                } else {
                  final uri = Uri.tryParse(url!);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    print('URL tidak valid atau tidak bisa dibuka');
                  }
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                color: Colors.white,
                child: Text(
                  'Lihat Lampiran',
                  style: interSmallRegular.copyWith(
                    color: Color(0xFF222CF4),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF222CF4),
                  ),
                ),
              ),
            )
            : Text(
              '-',
              style: interSmallRegular.copyWith(color: Color(0xFF4A4848)),
            ),
        SizedBox(height: 8),
      ],
    );
  }
}
