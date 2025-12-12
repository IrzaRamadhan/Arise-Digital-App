import 'package:flutter/material.dart';

import '../../../shared/theme.dart';

class DataTextItem extends StatelessWidget {
  final String title;
  final double widthTitle;
  final String value;
  const DataTextItem({
    super.key,
    required this.title,
    required this.widthTitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        SizedBox(
          width: widthTitle,
          child: Text(title, style: interSmallRegular),
        ),
        Text(' : ', style: interSmallRegular),
        Expanded(child: Text(value, style: interSmallRegular)),
      ],
    );
  }
}
