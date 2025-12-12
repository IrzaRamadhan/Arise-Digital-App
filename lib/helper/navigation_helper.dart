import 'package:flutter/material.dart';

class NavigationHelper {
  // Push ke halaman baru
  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Push dan ganti halaman sebelumnya
  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // Push dan hapus semua halaman sebelumnya
  static Future<T?> pushAndRemoveUntil<T>(
    BuildContext context,
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => page),
      predicate ?? (Route<dynamic> route) => false,
    );
  }

  // Pop halaman saat ini
  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
