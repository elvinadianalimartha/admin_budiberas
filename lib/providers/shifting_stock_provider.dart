import 'package:budiberas_admin_9701/models/shift_stock_model.dart';
import 'package:budiberas_admin_9701/services/shifitng_stock_service.dart';
import 'package:budiberas_admin_9701/services/suggestion_product_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class ShiftingStockProvider with ChangeNotifier{
  List<ShiftStockModel> _shiftStocks = [];
  List<ProductModel> _sourceProductList = [];
  List<ProductModel> _destProductList = [];

  bool loading = false;
  bool isSourceProductSet = false;

  int? maxQty;

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

  Future<void> getSourceProductSuggestions(String query) async {
    try{
      List<ProductModel> sourceProductList = await SuggestionProductService().getCanBeRetailedProduct(query);
      _sourceProductList = sourceProductList;
    } catch(e){
      print(e);
    }
  }

  validateSourceProduct(String valueFilled){
    //check apakah value yg dimasukkan ada di list suggestion produk asal
    bool exist = _sourceProductList.any(
        (_sourceProduct) => _sourceProduct.name.toLowerCase() == valueFilled.toLowerCase()
    );
    return exist;
  }

  Future<void> getDestProductSuggestions(String query, int sourceProdId) async {
    try{
      List<ProductModel> destProductList = await SuggestionProductService().getDestinationProduct(query: query, sourceProductId: sourceProdId);
      _destProductList = destProductList;
    } catch(e){
      print(e);
    }
  }

  validateDestProduct(String valueFilled){
    bool exist = _destProductList.any(
            (_dest) => _dest.name.toLowerCase() == valueFilled.toLowerCase()
    );
    return exist;
  }

  sourceIsSet() {
    isSourceProductSet = true;
    notifyListeners();
  }

  sourceIsNotSet() {
    isSourceProductSet = false;
    notifyListeners();
  }

  setMaxShiftQty(int qty) {
    isSourceProductSet = true;
    maxQty = qty;
    notifyListeners();
    print(maxQty);
  }

  void disposeValue() {
    isSourceProductSet = false;
    maxQty = null;
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