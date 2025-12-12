import 'package:flutter/material.dart';

import '../../shared/theme.dart';

class NewPageProgressIndicator extends StatelessWidget {
  const NewPageProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(child: CircularProgressIndicator(color: primary1)),
    );
  }
}
