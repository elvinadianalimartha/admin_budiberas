import 'package:budiberas_admin_9701/services/notification_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier{
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  String errorMessage = '';

  Future<bool> login({
    required String email,
    required String password
  }) async {
    try {
      UserModel user = await AuthService().login(
        email: email,
        password: password,
      );
      _user = user;
      notifyListeners();
      return true;
    }catch(e) {
      print(e);
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      if(await AuthService().logout()) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> fetchDataUser(String token) async {
    try {
      UserModel user = await AuthService().fetchDataUser(
        token: token,
      );
      _user = user; //berhasil fetch data by token yg disimpan di shared pref
    }catch(e) {
      print(e);
    }
  }

  Future<bool> updateFcmToken({
    required String token,
    required int userId,
    required String fcmToken,
  }) async {
    try {
      if(await AuthService().updateFcmToken(
        token: token,
        userId: userId,
        fcmToken: fcmToken,
      )) {
        return true;
      } else {
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }

  String? fcmTokenUser;

  Future<void> getFcmToken(int userId) async {
    try {
      String token = await NotificationService().getFcmTokenUser(userId: userId);
      fcmTokenUser = token;
    }catch(e) {
      print(e);
      fcmTokenUser = null;
    }
  }
}