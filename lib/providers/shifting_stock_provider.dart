import 'package:budiberas_admin_9701/models/shift_stock_model.dart';
import 'package:budiberas_admin_9701/services/shifitng_stock_service.dart';
import 'package:budiberas_admin_9701/services/suggestion_product_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class ShiftingStockProvider with ChangeNotifier{
  List<ShiftStockModel> _shiftStocks = [];
  List<ProductModel> _sourceProductList = [];
  List<ProductModel> _destProductList = [];

  DateTime? _searchByDate;

  bool loading = false;
  bool sourceProductValue = false;
  bool qtyShiftValue = false;
  bool destProductValue = false;

  int? maxQty;

  //Jika owner mau mengganti destination qty
  bool clickChangeDestQty = false;
  late int _destQtyToChange;
  int get destQtyToChange => _destQtyToChange;

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

  setMaxShiftQty(int qty) {
    sourceProductValue = true;
    maxQty = qty;
    notifyListeners();
    print(maxQty);
  }

  sourceIsNotSet() {
    sourceProductValue = false;
    maxQty = null;
    notifyListeners();
  }

  setQtyValue(bool val){
    qtyShiftValue = val;
    notifyListeners();
  }

  setDestinationValue(bool val) {
    destProductValue = val;
    notifyListeners();
  }

  //NOTE: bagian ini dipanggil jika owner mau ganti destination qty
  //yg sebelumnya sdh dihitung scr otomatis oleh sistem
  clickToChangeDestQty(bool val) {
    clickChangeDestQty = val;
    notifyListeners();
  }

  setInitDestQty(int initDestQty) {
    _destQtyToChange = initDestQty;
    notifyListeners();
  }

  reduceDestQty() {
    _destQtyToChange--;
    notifyListeners();
  }

  addDestQty() {
    _destQtyToChange++;
    notifyListeners();
  }

  //NOTE: semua value data di-reset atau dikembalikan ke awal ketika owner sudah tdk berada di page ini
  void disposeValue() {
    loading = false;
    sourceProductValue = false;
    maxQty = null;
    qtyShiftValue = false;
    destProductValue = false;
    clickChangeDestQty = false;
  }

  //NOTE: bagian getShiftStocks ke bawah ini untuk melakukan aksi tampil, alihkan, dan batal
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
    required int destQty,
  }) async {
    try{
      if(await ShiftingStockService().shiftingStock(
        sourceProductId: sourceProductId,
        destProductId: destProductId,
        quantity: quantity,
        destQty: destQty,
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