import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../shared/shared_values.dart';
import '../models/user_form_model.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

class UserService {
  Future<Either<String, UserModel>> getUser() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .get(
            Uri.parse('$baseUrl/api/me'),
            headers: {'Accept': 'application/json', 'Authorization': token},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (getUser) : ${res.statusCode}');
      if (res.statusCode == 200) {
        print(jsonDecode(res.body)['user']);
        return Right(UserModel.fromJson(jsonDecode(res.body)['user']));
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

  Future<Either<String, UserModel>> updateUser(
    UserFormModel data,
    String? img,
  ) async {
    try {
      final token = AuthService().getToken();
      var boundary = '------${DateTime.now().millisecondsSinceEpoch}------';
      var headers = {
        'Accept': 'multipart/form-data; boundary=$boundary',
        'Authorization': token,
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/profile'),
      );

      if (img != null) {
        request.files.add(await http.MultipartFile.fromPath('avatar', img));
      }

      request.headers.addAll(headers);
      request.fields.addAll(data.toJson());

      http.StreamedResponse res = await request.send().timeout(
        const Duration(seconds: 10),
      );

      print('Status Code (updateUser) : ${res.statusCode}');
      if (res.statusCode == 200) {
        String responseBody = await res.stream.bytesToString();
        UserModel user = UserModel.fromJson(jsonDecode(responseBody)['user']);
        await storeCredentialToLocal(user);
        return Right(user);
      } else if (res.statusCode == 401) {
        return const Left('Unauthorized');
      } else {
        return const Left('Terjadi Kesalahan, Coba Kembali');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet');
    } catch (e) {
      return const Left('Periksa Koneksi Internet');
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      var box = Hive.box('credentials');
      await box.put('name', user.name);
      await box.put('email', user.email);
      await box.put('username', user.username);
    } catch (e) {
      rethrow;
    }
  }
}
