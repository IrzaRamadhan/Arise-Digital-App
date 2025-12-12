import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';

class ForgotPasswordService {
  Future<Either<String, String>> resendOtp({required String email}) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/forgot-password'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: {'email': email},
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (resendOtp) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(jsonDecode(res.body)['message']);
      } else if (res.statusCode != 500) {
        return Left(jsonDecode(res.body)['message']);
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, String>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/verify-otp'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: {'email': email, 'otp': otp},
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (verifyOtp) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(jsonDecode(res.body)['reset_token']);
      } else if (res.statusCode != 500) {
        return Left(jsonDecode(res.body)['message']);
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<Either<String, String>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/reset-password'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: {
              'email': email,
              'reset_token': otp,
              "password": newPassword,
              "password_confirmation": confirmPassword,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (resetPassword) : ${res.statusCode}');
      if (res.statusCode == 200) {
        return Right(jsonDecode(res.body)['message']);
      } else if (res.statusCode != 500) {
        return Left(jsonDecode(res.body)['message']);
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }
}
