import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<FilePickerResult?> selectFile(List<String> allowedExtensions) async {
  FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );
  return resultFile;
}

String convertToYMD(String ddMMyyyy) {
  try {
    final parts = ddMMyyyy.split('/');
    if (parts.length != 3) return ddMMyyyy;
    final day = parts[0].padLeft(2, '0');
    final month = parts[1].padLeft(2, '0');
    final year = parts[2];
    return '$year-$month-$day';
  } catch (e) {
    return ddMMyyyy;
  }
}

int? toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is String) return int.tryParse(v);
  return null;
}

String toRupiah(int amount) {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return currencyFormat.format(amount);
}

String toRupiahDecimal(double amount) {
  final NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 2, // mempertahankan 2 desimal
  );
  return currencyFormat.format(amount);
}

Color hexToColor(String code) {
  return Color(int.parse(code.replaceFirst('#', '0xff')));
}

String dmyToYmd(String inputDate) {
  final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
  final DateFormat outputFormat = DateFormat('yyyy-MM-dd');
  final String ouputDate = outputFormat.format(inputFormat.parse(inputDate));
  return ouputDate;
}

String ymdToDmy(String inputDate) {
  final DateFormat inputFormat = DateFormat('yyyy-MM-dd');
  final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
  final String ouputDate = outputFormat.format(inputFormat.parse(inputDate));
  return ouputDate;
}
