import 'dart:convert';
import 'package:budiberas_admin_9701/services/app_exception.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;

class AuthService{
  String baseUrl = constants.baseUrl + '/user';

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {

    var url = '$baseUrl/loginAdmin';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
      'fcm_token': await FirebaseMessaging.instance.getToken()
    }); //utk kirim data harus di-encode dulu

    var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data['user']);
      user.token = 'Bearer ' + data['access_token'];

      return user;
    } else if(response.statusCode == 403) {
      throw AppException('Akses gagal! Anda bukan admin');
    } else if(response.statusCode == 500) {
      throw AppException('Gagal login! Email atau kata sandi salah');
    } else {
      throw AppException('Gagal login!');
    }
  }

  Future<bool> logout() async {
    var url = '$baseUrl/logout';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Gagal logout!');
    }
  }

  Future<UserModel> fetchDataUser({
    required String token,
  }) async {

    var url = '$baseUrl/fetchData';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200){
      var data = jsonDecode(response.body)['data'];
      UserModel user = UserModel.fromJson(data);
      user.token = token;

      return user;
    } else {
      throw Exception('Gagal ambil data user!');
    }
  }

  Future<bool> updateFcmToken({
    required String token,
    required int userId,
    required String fcmToken,
  }) async {
    var url = '$baseUrl/userFcmToken/$userId';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'fcm_token': fcmToken,
    });

    var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200){
      return true;
    } else {
      throw Exception('FCM token gagal diperbarui!');
    }
  }
}