import 'dart:convert';

import 'package:budiberas_admin_9701/models/report_daily_model.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

import '../models/report_soldout_model.dart';

class ReportService {
  String baseUrl = constants.baseUrl;

  Future<int> countNewOrder() async {
    var url = '$baseUrl/countNewOrder';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil jumlah pesanan baru');
    }
  }

  Future reportDailySales() async{
    var url = '$baseUrl/reportDailySales';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['detailReport'];
      List<ReportDailyModel> dailySalesDetail = [];

      for(var item in data) {
        dailySalesDetail.add(ReportDailyModel.fromJson(item));
      }

      int omzet = jsonDecode(response.body)['data']['omzet'];

      Map<String, dynamic> reportDailySales = {
        'omzet': omzet,
        'detail': dailySalesDetail
      };
      return reportDailySales;
    } else {
      throw Exception('Laporan penjualan hari ini gagal diambil!');
    }
  }

  Future<List<ReportSoldOutModel>> reportSoldOut() async{
    var url = '$baseUrl/soldOutProduct';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body);
      List<ReportSoldOutModel> reportSoldOut = [];

      for(var item in data) {
        reportSoldOut.add(ReportSoldOutModel.fromJson(item));
      }

      return reportSoldOut;
    } else {
      throw Exception('Laporan produk habis berhasil diambil!');
    }
  }
}