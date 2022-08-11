import 'dart:convert';
import 'package:budiberas_admin_9701/services/app_exception.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;

class AuthService{
  String baseUrl = constants.baseUrl + '/user';

  Future<UserModel> login({
    String? email,
    String? password
  }) async {

    var url = '$baseUrl/loginAdmin';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'email': email,
      'password': password,
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

  Future<bool> logout(String token) async {
    var url = '$baseUrl/logout';

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
}