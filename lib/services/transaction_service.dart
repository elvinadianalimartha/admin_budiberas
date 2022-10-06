import 'dart:convert';

import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';

class TransactionService {
  String baseUrl = constants.baseUrl;

  Future getTransactions({
    String? shippingType,
    String? searchQuery,
    required int page,
    List<String>? status,
  }) async {
    var url = '$baseUrl/transactionsAdmin';
    String token = await constants.getTokenAdmin();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    Map<String, dynamic> qParams = {
      'shippingType': shippingType?.toLowerCase(),
      'searchQuery': searchQuery?.toLowerCase(),
      'page': page.toString(),
    };

    if(status != null) {
      for(int i=0; i < status.length; i++) {
        qParams.addAll({'status[$i]': status[i]});
      }
    }

    var response = await http.get(
      Uri.parse(url).replace(queryParameters: qParams),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      int totalPageNumber = jsonDecode(response.body)['data']['last_page'];

      List<TransactionModel> transactionData = [];
      for(var item in data) {
        transactionData.add(TransactionModel.fromJson(item));
      }

      Map<String, dynamic> transactions = {
        'data': transactionData,
        'totalPage': totalPageNumber
      };

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