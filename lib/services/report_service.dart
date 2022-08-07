import 'dart:convert';

import 'package:budiberas_admin_9701/models/report_annual_model.dart';
import 'package:budiberas_admin_9701/models/report_daily_model.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:budiberas_admin_9701/models/report_monthly_model.dart';
import 'package:budiberas_admin_9701/models/report_remaining_stock_model.dart';
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

  Future reportDailySales() async{
    var url = '$baseUrl/reportDailySales';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      int omzet = jsonDecode(response.body)['data']['omzet'];

      List data = jsonDecode(response.body)['data']['detailReport'];
      List<ReportDailyModel> dailySalesDetail = [];

      for(var item in data) {
        dailySalesDetail.add(ReportDailyModel.fromJson(item));
      }

      Map<String, dynamic> reportDailySales = {
        'omzet': omzet,
        'detail': dailySalesDetail
      };
      return reportDailySales;
    } else {
      throw Exception('Laporan penjualan hari ini gagal diambil!');
    }
  }

  Future reportMonthlySales({required int month}) async{
    var url = '$baseUrl/reportMonthlySales/$month';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      int monthlyOmzet = jsonDecode(response.body)['data']['omzet'];

      List data = jsonDecode(response.body)['data']['reportPerCategory'];
      List<ReportMonthlyModel> monthlySalesDetail = [];

      for(var item in data) {
        monthlySalesDetail.add(ReportMonthlyModel.fromJson(item));
      }

      Map<String, dynamic> reportMonthlySales = {
        'monthlyOmzet': monthlyOmzet,
        'monthlySalesDetail': monthlySalesDetail
      };
      return reportMonthlySales;
    } else {
      throw Exception('Laporan penjualan bulanan gagal diambil!');
    }
  }

  Future reportAnnualSales({required String chosenYear}) async{
    var url = '$baseUrl/reportAnualSales';
    var headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> qParams = {
      'chosen_year': chosenYear.toLowerCase(),
    };

    var response = await http.get(
        Uri.parse(url).replace(queryParameters: qParams),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      int totalOmzet = int.parse(jsonDecode(response.body)['data']['totalOmzet'].toString());
      double totalTax = double.parse(jsonDecode(response.body)['data']['totalTax'].toString());

      List data = jsonDecode(response.body)['data']['detailReport'];
      List<ReportAnnualModel> annualSales = [];

      for(var item in data) {
        annualSales.add(ReportAnnualModel.fromJson(item));
      }

      Map<String, dynamic> reportAnnualSales = {
        'totalOmzet': totalOmzet,
        'totalTax': totalTax,
        'annualSalesDetail': annualSales
      };
      return reportAnnualSales;
    } else {
      throw Exception('Laporan penjualan tahunan gagal diambil!');
    }
  }

  Future reportRemainingStock({required String chosenDate}) async{
    var url = '$baseUrl/reportRemainingStock';
    var headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> qParams = {
      'chosen_date': chosenDate,
    };

    var response = await http.get(
        Uri.parse(url).replace(queryParameters: qParams),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<ReportRemainingStockModel> remainingStock = [];

      for(var item in data) {
        remainingStock.add(ReportRemainingStockModel.fromJson(item));
      }

      return remainingStock;
    } else {
      throw Exception('Laporan sisa stok gagal diambil!');
    }
  }
}