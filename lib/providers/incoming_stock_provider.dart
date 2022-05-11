import 'package:budiberas_admin_9701/models/incoming_stock_model.dart';
import 'package:budiberas_admin_9701/services/incoming_stock_service.dart';
import 'package:flutter/cupertino.dart';

class IncomingStockProvider with ChangeNotifier{
  List<IncomingStockModel> _addedIncomingStock = [];
  List<IncomingStockModel> _returnIncomingStock = [];

  bool loading = false;

  DateTime? _searchAddedDate;
  DateTime? _searchReturnDate;

  List<IncomingStockModel> get addedIncomingStocks => _searchAddedDate == null
      ? _addedIncomingStock
      : _addedIncomingStock.where(
          (stock) => stock.incomingDate == _searchAddedDate
  ).toList();

  List<IncomingStockModel> get returnIncomingStocks => _searchReturnDate == null
      ? _returnIncomingStock
      : _returnIncomingStock.where(
          (stock) => stock.incomingDate == _searchReturnDate
  ).toList();

  set addedIncomingStocks(List<IncomingStockModel> incomingStocks) {
    _addedIncomingStock = incomingStocks;
    notifyListeners();
  }

  set returnIncomingStocks(List<IncomingStockModel> incomingStocks) {
    _returnIncomingStock = incomingStocks;
    notifyListeners();
  }

  Future<void> getIncomingStocks({required String statusParam}) async {
    loading = true;
    try{
      List<IncomingStockModel> incomingStocks = await IncomingStockService().getIncomingStock(status: statusParam);
      if(statusParam == 'Tambah stok'){
        _addedIncomingStock = incomingStocks;
      } else if(statusParam == 'Retur dari pembeli') {
        _returnIncomingStock = incomingStocks;
      }
      loading = false;
      notifyListeners();
    } catch(e) {
      print(e);
    }
  }

  void searchAddedIncomingStock(DateTime? searchDate) {
    _searchAddedDate = searchDate;
    notifyListeners();
  }

  void searchReturnIncomingStock(DateTime? searchDate) {
    _searchReturnDate = searchDate;
    notifyListeners();
  }

  Future<bool> createIncomingStock({
    required int productId,
    required int quantity,
    required String incomingStatus,
  }) async {
    try{
      if(await IncomingStockService().createIncomingStock(
        productId: productId,
        quantity: quantity,
        incomingStatus: incomingStatus,
      )) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteIncomingStock({
    required int id,
  }) async {
    try{
      if(await IncomingStockService().deleteIncomingStock(id: id)) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateIncomingStock({
    required int id,
    required int quantity,
  }) async {
    try{
      if(await IncomingStockService().updateIncomingStock(id: id, quantity: quantity)) {
        notifyListeners();
        return true;
      } else {
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }
}