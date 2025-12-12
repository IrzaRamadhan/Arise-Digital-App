import 'dart:async';
import 'dart:convert';

import 'package:arise/data/models/kompetensi_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import 'auth_service.dart';

class KompetensiService {
  Future<Either<String, List<KompetensiModel>>> getKompetensi() async {
    try {
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/kompetensi'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getKompetensi) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(
          List<KompetensiModel>.from(
            jsonDecode(
              res.body,
            )['data'].map((question) => KompetensiModel.fromJson(question)),
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
