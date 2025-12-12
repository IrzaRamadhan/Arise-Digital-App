import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import 'auth_service.dart';

class NotificationService {
  Future<Either<String, String>> markAllRead() async {
    try {
      final token = AuthService().getToken();

      final res = await http
          .get(
            Uri.parse('$baseUrl/api/notifications/mark-all-read'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (markAllRead) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right('success');
      } else if (res.statusCode == 401) {
        final refresh = await AuthService().refreshToken();
        return Left(refresh);
      } else {
        return const Left('Server Error');
      }
    } on TimeoutException {
      return const Left('Connection');
    } catch (e) {
      return const Left('Connection');
    }
  }
}
