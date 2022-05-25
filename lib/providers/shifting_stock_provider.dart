import 'package:budiberas_admin_9701/models/shift_stock_model.dart';
import 'package:budiberas_admin_9701/services/shifitng_stock_service.dart';
import 'package:flutter/cupertino.dart';

class ShiftingStockProvider with ChangeNotifier{
  List<ShiftStockModel> _shiftStocks = [];

  bool loading = false;

  int maxQty = 0;

  DateTime? _searchByDate;

  List<ShiftStockModel> get shiftStocks => _searchByDate == null
    ? _shiftStocks
    : _shiftStocks.where(
        (stock) => stock.shiftingDate == _searchByDate
      ).toList();

  set shiftStocks(List<ShiftStockModel> shiftStocks) {
    _shiftStocks = shiftStocks;
    notifyListeners();
  }

  setMaxShiftQty(int qty) {
    maxQty = qty;
    notifyListeners();
    print(maxQty);
  }

  Future<void> getShiftStocks() async{
    loading = true;
    try {
      List<ShiftStockModel> shiftStocks = await ShiftingStockService().getShiftStock();
      _shiftStocks = shiftStocks;
    } catch(e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }

  void searchShiftStockByDate(DateTime? searchDate) {
    _searchByDate = searchDate;
    notifyListeners();
  }

  Future<bool> shiftingStock({
    required int sourceProductId,
    required int destProductId,
    required int quantity,
  }) async {
    try{
      if(await ShiftingStockService().shiftingStock(
        sourceProductId: sourceProductId,
        destProductId: destProductId,
        quantity: quantity
      )) {
        return true;
      } else {
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> cancelShiftStock({
    required int id,
  }) async {
    try{
      if(await ShiftingStockService().cancelShiftingStock(id: id)) {
        return true;
      }else{
        return false;
      }
    }catch(e){
      print(e);
      return false;
    }
  }
}