import 'package:flutter/material.dart';

import '../shared/theme.dart';

class StatusBadge1 extends StatelessWidget {
  final String status;
  const StatusBadge1({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'pending':
        textColor = Color(0xFFF7AC5F);
        bgColor = Color(0xFFF58612).withValues(alpha: 0.2);
        break;

      case 'aktif':
        textColor = Color(0xFF34AE1C);
        bgColor = Color(0xFF11D011).withValues(alpha: 0.2);
        break;

      case 'non_aktif':
        textColor = Colors.blue;
        bgColor = Colors.blue.shade100;
        break;

      case 'pemeliharaan':
        textColor = Color(0xFF2B3791);
        bgColor = Color(0xFF2B3791).withValues(alpha: 0.2);
        break;

      case 'ditolak':
        textColor = Color(0xFFF22121);
        bgColor = Color(0xFFFFE7E7);
        break;

      case 'dihapus':
        textColor = Colors.grey;
        bgColor = Colors.grey.shade200;
        break;

      default:
        textColor = Colors.grey;
        bgColor = Colors.grey.shade200;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        status
            .replaceAll('_', ' ')
            .replaceFirst(status[0], status[0].toUpperCase()),
        style: interSmallRegular.copyWith(color: textColor),
      ),
    );
  }
}

class StatusBadge2 extends StatelessWidget {
  final String status;
  const StatusBadge2({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'baik':
        bgColor = Color(0xFF2CBC0F);
        textColor = Color(0xFFFBFBFB);
        break;

      default:
        bgColor = Color(0xFFF7AC5F);
        textColor = Color(0xFFFBFBFB);
    }

    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 50),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status
            .replaceAll('-', ' ')
            .replaceFirst(status[0], status[0].toUpperCase()),
        style: interSmallRegular.copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class StatusBadge3 extends StatelessWidget {
  final bool isActive;
  const StatusBadge3({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    String text;
    Color textColor;
    Color bgColor;

    if (isActive) {
      text = 'Aktif';
      textColor = Color(0xFF34AE1C);
      bgColor = Color(0xFF11D011).withValues(alpha: 0.2);
    } else {
      text = 'Non-aktif';
      textColor = Color(0xFFF22121);
      bgColor = Color(0xFFFFE7E7);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: textColor),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(text, style: interSmallRegular.copyWith(color: textColor)),
    );
  }
}

class StatusBadge4 extends StatelessWidget {
  final String status;
  const StatusBadge4({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'pending':
        textColor = Color(0xFFF7AC5F);
        bgColor = Color(0xFFF58612).withValues(alpha: 0.2);
        break;

      case 'aktif':
        textColor = Color(0xFF34AE1C);
        bgColor = Color(0xFF11D011).withValues(alpha: 0.2);
        break;

      case 'non_aktif':
        textColor = Colors.blue;
        bgColor = Colors.blue.shade100;
        break;

      case 'pemeliharaan':
        textColor = Color(0xFF2B3791);
        bgColor = Color(0xFF2B3791).withValues(alpha: 0.2);
        break;

      case 'ditolak':
        textColor = Color(0xFFF22121);
        bgColor = Color(0xFFFFE7E7);
        break;

      case 'dihapus':
        textColor = Colors.grey;
        bgColor = Colors.grey.shade200;
        break;

      default:
        textColor = Colors.grey;
        bgColor = Colors.grey.shade200;
    }

    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 50),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status
            .replaceAll('_', ' ')
            .replaceFirst(status[0], status[0].toUpperCase()),
        style: interSmallRegular.copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class StatusBadge5 extends StatelessWidget {
  final String status;
  const StatusBadge5({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'terjadwal':
        textColor = Colors.blue;
        bgColor = Colors.blue.shade100;
        break;

      default:
        textColor = Color(0xFF34AE1C);
        bgColor = Color(0xFF11D011).withValues(alpha: 0.2);
    }

    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 50),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status
            .replaceAll('_', ' ')
            .replaceFirst(status[0], status[0].toUpperCase()),
        style: interSmallRegular.copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class StatusBadge6 extends StatelessWidget {
  final String status;
  const StatusBadge6({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status) {
      case 'Rendah':
        textColor = Color(0xFFF22121);
        bgColor = Color(0xFFFFE7E7);
        break;

      case 'Sedang':
        textColor = Color(0xFFF7AC5F);
        bgColor = Color(0xFFF58612).withValues(alpha: 0.2);
        break;

      case 'Tinggi':
        textColor = Color(0xFF34AE1C);
        bgColor = Color(0xFF11D011).withValues(alpha: 0.2);
        break;

      default:
        textColor = Color(0xFFF22121);
        bgColor = Color(0xFFFFE7E7);
        break;
    }
    return Container(
      padding: EdgeInsets.all(4),
      constraints: BoxConstraints(minWidth: 50),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status
            .replaceAll('_', ' ')
            .replaceFirst(status[0], status[0].toUpperCase()),
        style: interSmallRegular.copyWith(color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
