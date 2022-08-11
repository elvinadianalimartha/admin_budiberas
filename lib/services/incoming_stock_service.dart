import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budiberas_admin_9701/models/incoming_stock_model.dart';

import '../constants.dart' as constants;

class IncomingStockService{
  String baseUrl = constants.baseUrl;

  Future<List<IncomingStockModel>> getIncomingStock({String? status}) async {
    var url = '$baseUrl/incomingStock';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    Map<String, dynamic> qParams = {
      'status': status?.toLowerCase(),
    };

    var response = await http.get(
        Uri.parse(url).replace(queryParameters: qParams),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];

      List<IncomingStockModel> incomingStocks = [];

      for(var item in data) {
        incomingStocks.add(IncomingStockModel.fromJson(item));
      }

      return incomingStocks;
    } else {
      throw Exception('Data stok masuk gagal diambil!');
    }
  }

  Future<bool> createIncomingStock({
    int productId = 0,
    int quantity = 0,
    String incomingStatus = '',
  }) async {
    var url = '$baseUrl/incomingStock';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'product_id': productId,
      'quantity': quantity,
      'incoming_status': incomingStatus,
    });

    var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data stok gagal ditambahkan');
    }
  }

  Future<bool> deleteIncomingStock({
    int id = 0,
  }) async {
    var url = '$baseUrl/incomingStock/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data stok masuk gagal dihapus');
    }
  }

  Future<bool> updateIncomingStock({
    required int id,
    required int quantity,
  }) async {
    var url = '$baseUrl/incomingStock/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'quantity': quantity
    });

    var response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data jumlah stok masuk gagal diubah');
    }
  }
}