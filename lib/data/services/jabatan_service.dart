import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/jabatan_model.dart';
import 'auth_service.dart';

class JabatanService {
  Future<Either<String, List<JabatanModel>>> getJabatan() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/jabatan'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getJabatan) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<JabatanModel>.from(
            jsonDecode(
              res.body,
            )['data'].map((question) => JabatanModel.fromJson(question)),
          ).toList(),
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
