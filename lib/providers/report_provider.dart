import 'package:budiberas_admin_9701/models/report_annual_model.dart';
import 'package:budiberas_admin_9701/models/report_monthly_model.dart';
import 'package:budiberas_admin_9701/models/report_remaining_stock_model.dart';
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

  //=========================== STOK HABIS =====================================
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

      int omzet = reportDailySalesResult['omzet'];
      dailyOmzet = omzet;

      List<ReportDailyModel> detail = reportDailySalesResult['detail'];
      _dailySalesDetail = detail;
    } catch(e) {
      print(e);
      dailyOmzet = 0;
      _dailySalesDetail = [];
    }
    loadingDaily = false;
    notifyListeners();
  }

  //=========================== PENJUALAN BULANAN ==============================
  List<ReportMonthlyModel> _monthlySalesDetail = [];

  List<ReportMonthlyModel> get monthlySalesDetail => _monthlySalesDetail;

  set monthlySalesDetail(List<ReportMonthlyModel> value) {
    _monthlySalesDetail = value;
    notifyListeners();
  }

  bool loadingMonthly = false;
  int monthlyOmzet = 0;

  Future<void> reportMonthlySales({required String month, required String year}) async{
    loadingMonthly = true;
    try{
      var reportMonthlySalesResult = await ReportService().reportMonthlySales(month: month, year: year);

      int omzet = reportMonthlySalesResult['monthlyOmzet'];
      monthlyOmzet = omzet;

      List<ReportMonthlyModel> detail = reportMonthlySalesResult['monthlySalesDetail'];
      _monthlySalesDetail = detail;
    } catch(e) {
      print(e);
      monthlyOmzet = 0;
      _monthlySalesDetail = [];
    }
    loadingMonthly = false;
    notifyListeners();
  }

  //========================= PENJUALAN TAHUNAN ================================
  List<ReportAnnualModel> _annualSales = [];

  List<ReportAnnualModel> get annualSales => _annualSales;

  set annualSales(List<ReportAnnualModel> value) {
    _annualSales = value;
    notifyListeners();
  }

  bool loadingAnnual = false;
  int totalAnnualOmzet = 0;
  double totalTax = 0.0;

  Future<void> reportAnnualSales({required String chosenYear}) async{
    loadingAnnual = true;
    try {
      var reportAnnualSalesResult = await ReportService().reportAnnualSales(chosenYear: chosenYear);

      totalAnnualOmzet = reportAnnualSalesResult['totalOmzet'];
      totalTax = reportAnnualSalesResult['totalTax'];

      List<ReportAnnualModel> detail = reportAnnualSalesResult['annualSalesDetail'];
      _annualSales = detail;
    } catch (e) {
      print(e);
      _annualSales = [];
      totalAnnualOmzet = 0;
      totalTax = 0.0;
    }
    loadingAnnual = false;
    notifyListeners();
  }

  //=========================== LAPORAN SISA STOK ==============================
  List<ReportRemainingStockModel> _remainingStocks = [];

  List<ReportRemainingStockModel> get remainingStocks => _remainingStocks;

  set remainingStocks(List<ReportRemainingStockModel> value) {
    _remainingStocks = value;
    notifyListeners();
  }

  bool loadingRemainingStock = false;

  Future<void> reportRemainingStock({required String chosenDate}) async{
    loadingRemainingStock = true;
    try{
      List<ReportRemainingStockModel> remainingStocksData = await ReportService().reportRemainingStock(chosenDate: chosenDate);
      _remainingStocks = remainingStocksData;
    } catch(e) {
      print(e);
      _remainingStocks = [];
    }
    loadingRemainingStock = false;
    notifyListeners();
  }
}