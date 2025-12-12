import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/dashboard_model.dart';
import 'auth_service.dart';

class DashboardService {
  Future<Either<String, DashboardSummaryModel>> getDashboard(
    int dinasId,
  ) async {
    try {
      final token = AuthService().getToken();
      String url = '$baseUrl/api/dashboard/stats';
      if (dinasId != 0) {
        url += '?dinas_id=$dinasId';
      }

      final res = await http
          .get(
            Uri.parse(url),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getDashboard) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          DashboardSummaryModel.fromJson(jsonDecode(res.body)['data']),
        );
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
