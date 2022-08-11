import 'dart:convert';

import '../models/shipping_rates_model.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

class ShippingRateService {
  var baseUrl = constants.baseUrl;

  Future<List<ShippingRatesModel>> getShippingRates() async {
    var url = '$baseUrl/shippingRates';
    var headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      List<ShippingRatesModel> shippingRates = [];

      for(var item in data) {
        shippingRates.add(ShippingRatesModel.fromJson(item));
      }

      return shippingRates;
    } else {
      throw Exception('Gagal mengambil data biaya pengiriman');
    }
  }

  Future<bool> createSpecialRate({
    required double maxDistance,
    required double minOrderPrice,
    required double shippingPrice
  }) async {
    var url = '$baseUrl/specialShippingRates';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'max_distance': maxDistance,
      'min_order_price': minOrderPrice,
      'shipping_price': shippingPrice,
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
      throw Exception('Biaya khusus gagal ditambahkan');
    }
  }

  Future<bool> updateRate({
    required int id,
    double? maxDistance,
    int? minOrderPrice,
    required int shippingPrice
  }) async {
    var url = '$baseUrl/shippingRates/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'max_distance': maxDistance,
      'min_order_price': minOrderPrice,
      'shipping_price': shippingPrice,
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
      throw Exception('Ketentuan biaya pengantaran gagal diubah');
    }
  }

  Future<bool> deleteRate({
    required int id,
  }) async {
    var url = '$baseUrl/shippingRates/$id';
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
      throw Exception('Ketentuan biaya pengantaran gagal dihapus');
    }
  }
}