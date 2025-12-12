import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../shared/shared_values.dart';
import '../models/user_model.dart';

class AuthService {
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/login'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
            },
            body: {'login': email, 'password': password},
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (login) : ${res.statusCode}');
      if (res.statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonDecode(res.body)['user']);
        await storeCredentialToLocal(
          user,
          jsonDecode(res.body)['access_token'],
          jsonDecode(res.body)['user']['dinas'] != null
              ? jsonDecode(res.body)['user']['dinas']['id']
              : null,
        );
        return Right(user);
      } else if (res.statusCode == 401) {
        return Left(jsonDecode(res.body)['message']);
      } else if (res.statusCode == 403) {
        return Left('Forbidden');
      } else {
        return const Left('Terjadi Kesalahan, Coba Kembali');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet');
    } catch (e) {
      return const Left('Periksa Koneksi Internet');
    }
  }

  Future<String> refreshToken() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/refresh'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));

      print('Status Code (refresh) : ${res.statusCode}');
      if (res.statusCode == 200) {
        await updateToken(jsonDecode(res.body)['access_token']);
        return 'Try Again';
      } else {
        clearLocalStorage();
        return 'Unauthenticated';
      }
    } on TimeoutException {
      return 'Connection';
    } catch (e) {
      return 'Connection';
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final token = AuthService().getToken();
      final res = await http
          .post(
            Uri.parse('$baseUrl/api/logout'),
            headers: {
              'Accept': 'application/json',
              'X-Requested-With': 'XMLHttpRequest',
              'Authorization': token,
            },
          )
          .timeout(const Duration(seconds: 10));
      print('Status Code (logout) : ${res.statusCode}');
      if (res.statusCode == 200 || res.statusCode == 401) {
        clearLocalStorage();
        return const Right('Success');
      } else {
        return const Left('Terjadi Kesalahan Pada Server');
      }
    } on TimeoutException {
      return const Left('Periksa Koneksi Internet Anda');
    } catch (e) {
      return const Left('Periksa Koneksi Internet Anda');
    }
  }

  Future<void> storeCredentialToLocal(
    UserModel user,
    String token,
    int? dinasId,
  ) async {
    try {
      var box = Hive.box('credentials');
      await box.put('token', token);
      await box.put('dinas_id', dinasId);
      await box.put('name', user.name);
      await box.put('email', user.email);
      await box.put('username', user.username);
      final roleName = roles[user.roleId];
      await box.put('role', roleName);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateToken(String token) async {
    try {
      var box = Hive.box('credentials');
      await box.put('token', token);
    } catch (e) {
      rethrow;
    }
  }

  String getToken() {
    String token = '';
    var box = Hive.box('credentials');
    String? value = box.get('token');
    if (value != null) {
      token = 'Bearer $value';
    }
    return token;
  }

  int? getDinasId() {
    var box = Hive.box('credentials');
    int? value = box.get('dinas_id');
    return value;
  }

  String getName() {
    String name = '';
    var box = Hive.box('credentials');
    String? value = box.get('name');
    if (value != null) {
      name = value;
    }
    return name;
  }

  String getRole() {
    String role = '';
    var box = Hive.box('credentials');
    String? value = box.get('role');
    if (value != null) {
      role = value;
    }
    return role;
  }

  void clearLocalStorage() {
    var box = Hive.box('credentials');
    box.delete('token');
    box.delete('name');
    box.delete('email');
    box.delete('username');
    box.delete('role');
  }
}
