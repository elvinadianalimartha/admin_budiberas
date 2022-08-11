import 'dart:convert';

import '../constants.dart' as constants;
import 'package:http/http.dart' as http;
import '../models/out_stock_model.dart';

class OutStockService {
  String outStockUrl = constants.urlOutStock;

  Future<List<OutStockModel>> getOutStock() async {
    var url = outStockUrl;
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];

      List<OutStockModel> outStocks = [];

      for(var item in data) {
        outStocks.add(OutStockModel.fromJson(item));
      }

      return outStocks;
    } else {
      throw Exception('Data retur ke supplier gagal diambil!');
    }
  }

  Future<int> getMaxOutQty(int id) async {
    var url = '${constants.baseUrl}/maxOutQty/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    return int.parse(response.body);
  }

  Future<bool> createOutStock({
    int productId = 0,
    int quantity = 0,
    String outStatus = 'Retur ke supplier',
  }) async {
    var url = outStockUrl;
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'product_id': productId,
      'quantity': quantity,
      'out_status': outStatus,
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
      throw Exception('Data stok keluar gagal ditambahkan');
    }
  }

  Future<bool> deleteOutStock({
    int id = 0,
  }) async {
    var url = '$outStockUrl/$id';
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
      throw Exception('Data stok keluar gagal dihapus');
    }
  }

  Future<bool> updateOutStock({
    required int id,
    required int quantity,
  }) async {
    var url = '$outStockUrl/$id';
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
      throw Exception('Data jumlah stok keluar gagal diubah');
    }
  }
}