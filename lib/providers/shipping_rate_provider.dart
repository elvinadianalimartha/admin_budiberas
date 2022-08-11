import 'package:budiberas_admin_9701/services/shipping_rate_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/shipping_rates_model.dart';

class ShippingRateProvider with ChangeNotifier{
  List<ShippingRatesModel> _shippingRates = [];

  set shippingRates(List<ShippingRatesModel> value) {
    _shippingRates = value;
    notifyListeners();
  }

  ShippingRatesModel get standardShippingRates => _shippingRates.where((e) => e.shippingName.toLowerCase() == 'standar').first;

  List<ShippingRatesModel> get specialShippingRates => _shippingRates.where((e) => e.shippingName.toLowerCase() == 'khusus').toList();

  bool loadingGetRates = false;

  Future<void> getShippingRates() async {
    loadingGetRates = true;
    try {
      List<ShippingRatesModel> shippingRateData = await ShippingRateService().getShippingRates();
      _shippingRates = shippingRateData;
    } catch (e) {
      print(e);
    }
    loadingGetRates = false;
    notifyListeners();
  }

  Future<bool> createShippingRate({
    required double maxDistance,
    required double minOrderPrice,
    required double shippingPrice
  }) async {
    try{
      if(await ShippingRateService().createSpecialRate(
          maxDistance: maxDistance,
          minOrderPrice: minOrderPrice,
          shippingPrice: shippingPrice
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

  Future<bool> updateRate({
    required int id,
    double? maxDistance,
    int? minOrderPrice,
    required int shippingPrice
  }) async {
    try{
      if(await ShippingRateService().updateRate(
          id: id,
          shippingPrice: shippingPrice,
          maxDistance: maxDistance,
          minOrderPrice: minOrderPrice
      )) {
        _shippingRates.where((e) => e.id == id).first.shippingPrice = shippingPrice;
        _shippingRates.where((e) => e.id == id).first.maxDistance = maxDistance;
        _shippingRates.where((e) => e.id == id).first.minOrderPrice = minOrderPrice;
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

  Future<bool> deleteRate({
    required int id,
  }) async {
    try{
      if(await ShippingRateService().deleteRate(id: id)) {
        _shippingRates.removeWhere((e) => e.id == id);
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