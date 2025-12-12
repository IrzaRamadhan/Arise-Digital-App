import 'package:flutter/widgets.dart';

import '../../../../shared/theme.dart';

class DetailTextItem extends StatelessWidget {
  final String title;
  final String value;
  const DetailTextItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: interBodySmallSemibold.copyWith(color: Color(0xFF2B2B2B)),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: interSmallRegular.copyWith(color: Color(0xFF4A4848)),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
