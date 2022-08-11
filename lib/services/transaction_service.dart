import 'dart:convert';

import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';

class TransactionService {
  String baseUrl = constants.baseUrl;

  Future<List<TransactionModel>> getTransactions({String? shippingType, String? searchQuery}) async {
    var url = '$baseUrl/transactionsAdmin';
    String token = await constants.getTokenAdmin();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    Map<String, dynamic> qParams = {
      'shippingType': shippingType?.toLowerCase(),
      'searchQuery': searchQuery?.toLowerCase(),
    };

    var response = await http.get(
      Uri.parse(url).replace(queryParameters: qParams),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<TransactionModel> transactions = [];

      for(var item in data) {
        transactions.add(TransactionModel.fromJson(item));
      }

      return transactions;
    } else {
      throw Exception('Gagal mengambil data pesanan');
    }
  }

  Future<bool> updateStatus({
    required int transactionId,
    required String newStatus,
  }) async {
    var url = '$baseUrl/updateStatus/$transactionId';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var body = jsonEncode({
      'status': newStatus,
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
      throw Exception('Status transaksi gagal diperbarui');
    }
  }
}