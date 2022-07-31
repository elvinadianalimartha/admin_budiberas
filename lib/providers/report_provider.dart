import 'package:budiberas_admin_9701/models/report_soldout_model.dart';
import 'package:budiberas_admin_9701/services/report_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/report_daily_model.dart';

class ReportProvider with ChangeNotifier{
  int countNewOrder = 0;
  Future<void> getCountNewOrder() async {
    try{
      var newOrder = await ReportService().countNewOrder();
      countNewOrder = newOrder;
    } catch(e) {
      print(e);
    }
  }

  //=========================== PENJUALAN HARIAN ===============================
  List<ReportDailyModel> _dailySalesDetail = [];

  List<ReportDailyModel> get dailySalesDetail => _dailySalesDetail;

  set dailySalesDetail(List<ReportDailyModel> value) {
    _dailySalesDetail = value;
    notifyListeners();
  }

  bool loadingDaily = false;
  int dailyOmzet = 0;

  Future<void> reportDailySales() async{
    loadingDaily = true;
    try{
      var reportDailySalesResult = await ReportService().reportDailySales();
      int omzetDaily = reportDailySalesResult['omzet'];
      List<ReportDailyModel> detail = reportDailySalesResult['detail'];
      _dailySalesDetail = detail;
      dailyOmzet = omzetDaily;
    } catch(e) {
      print(e);
      _dailySalesDetail = [];
      dailyOmzet = 0;
    }
    loadingDaily = false;
    notifyListeners();
  }

  //=========================== STOK HABIS ======================================
  List<ReportSoldOutModel> _soldOut = [];

  List<ReportSoldOutModel> get soldOut => _soldOut;

  set soldOut(List<ReportSoldOutModel> value) {
    _soldOut = value;
    notifyListeners();
  }

  bool loadingSoldOut = false;
  Future<void> reportSoldOut() async{
    loadingSoldOut = true;
    try{
      List<ReportSoldOutModel> soldOut = await ReportService().reportSoldOut();
      _soldOut = soldOut;
    } catch(e) {
      print(e);
    }
    loadingSoldOut = false;
    notifyListeners();
  }
}