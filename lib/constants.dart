// const String baseUrl = 'http://192.168.100.36:8000/api';
// const String urlPhoto = 'http://192.168.100.36:8000/storage/';

import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://budiberas.pinulusuran.my.id/api';
const String urlPhoto = 'https://budiberas.pinulusuran.my.id/photoProduct/';

const String urlOutStock = baseUrl + '/outStock';

//NOTE: get token yg tersimpan di shared preference (diset saat login)
Future<String> getTokenAdmin() async{
  SharedPreferences loginData = await SharedPreferences.getInstance();
  var tokenAdmin = loginData.getString('tokenAdmin');
  return tokenAdmin.toString();
}