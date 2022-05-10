import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:budiberas_admin_9701/models/incoming_stock_model.dart';

import '../constants.dart' as constants;

class IncomingStockService{
  String baseUrl = constants.baseUrl;

  Future<List<IncomingStockModel>> getIncomingStock({String? status}) async {
    var url = '$baseUrl/incomingStock';
    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
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
}