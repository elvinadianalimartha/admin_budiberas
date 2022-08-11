import 'dart:convert';

import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:budiberas_admin_9701/models/shift_stock_model.dart';
import 'package:http/http.dart' as http;

class ShiftingStockService {
  String baseUrl = constants.baseUrl;

  Future<List<ShiftStockModel>> getShiftStock() async {
    var url = '$baseUrl/shiftStock';
    String token = await constants.getTokenAdmin();
    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];

      List<ShiftStockModel> shiftStocks = [];

      for(var item in data) {
        shiftStocks.add(ShiftStockModel.fromJson(item));
      }

      return shiftStocks;
    } else {
      throw Exception('Histori pengalihan stok gagal diambil');
    }
  }

  Future<bool> shiftingStock({
    required int sourceProductId,
    required int destProductId,
    required int quantity,
    required int destQty,
  }) async {
    var url = '$baseUrl/shiftingStock';
    String token = await constants.getTokenAdmin();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'product_id': sourceProductId,
      'shiftStockDestination': destProductId,
      'quantity': quantity,
      'destQty': destQty,
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
      throw Exception('Stok berhasil dialihkan');
    }
  }

  Future<bool> cancelShiftingStock({
    required int id,
  }) async {
    var url = '$baseUrl/cancelShiftStock/$id';
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
      throw Exception('Pengalihan stok gagal dibatalkan');
    }
  }
}