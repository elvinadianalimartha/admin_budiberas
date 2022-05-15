import 'package:budiberas_admin_9701/models/out_stock_model.dart';
import 'package:budiberas_admin_9701/services/out_stock_service.dart';
import 'package:flutter/cupertino.dart';

class OutStockProvider with ChangeNotifier{
  List<OutStockModel> _outStocks = [];

  bool loading = false;

  DateTime? _searchOutStock;

  List<OutStockModel> get outStocks => _searchOutStock == null
      ? _outStocks
      : _outStocks.where(
          (stock) => stock.outDate == _searchOutStock
        ).toList();

  set outStocks(List<OutStockModel> outStocks) {
    _outStocks = outStocks;
    notifyListeners();
  }

  Future<void> getOutStocks() async{
    loading = true;
    try{
      List<OutStockModel> outStocks = await OutStockService().getOutStock();
      _outStocks = outStocks;
      // loading = false;
      // notifyListeners();
    } catch(e) {
      print(e);
    }
    loading = false;
    notifyListeners();
  }

  void searchOutStock(DateTime? searchDate) {
    _searchOutStock = searchDate;
    notifyListeners();
  }

  Future<bool> createOutStock({
    required int productId,
    required int quantity,
    String outStatus = 'Retur ke supplier',
  }) async {
    try{
      if(await OutStockService().createOutStock(
        productId: productId,
        quantity: quantity,
        outStatus: outStatus,
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

  Future<bool> deleteOutStock({
    required int id,
  }) async {
    try{
      if(await OutStockService().deleteOutStock(id: id)) {
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

  Future<bool> updateOutStock({
    required int id,
    required int quantity,
  }) async {
    try{
      if(await OutStockService().updateOutStock(id: id, quantity: quantity)) {
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