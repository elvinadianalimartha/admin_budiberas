import 'dart:convert';
import 'dart:io';

import 'package:budiberas_admin_9701/models/product_model.dart';
import 'package:budiberas_admin_9701/services/product_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:pusher_client/pusher_client.dart';

class ProductProvider with ChangeNotifier{
  List<ProductModel> _products = [];
  bool loading = false;
  String _searchQuery = '';
  int selectedValue = 1;

  List<ProductModel> get products => _searchQuery.isEmpty
      ? _products
      : _products.where(
          (product) => product.name.toLowerCase().contains(_searchQuery)
      ).toList();

  set products(List<ProductModel> products) {
    _products = products;
    notifyListeners();
  }

  int? _countProduct;
  int? get productInTransaction => _countProduct;

  void disposeValues() {
    _searchQuery = '';
    //_products = [];
    notifyListeners();
  }

  Future<void> getProducts() async {
    loading = true;
    try{
      List<ProductModel> products = await ProductService().getProducts();
      _products = products;
      loading = false;
      notifyListeners();
    } catch(e) {
      print(e);
    }
  }

  void searchProduct(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void changeRetailedValue(int value) {
    if(value == 0) {
      selectedValue = 0;
    } else {
      selectedValue = 1;
    }
    notifyListeners();
  }

  Future<bool> createProduct({
    required int categoryId,
    required String name,
    required double size,
    required double price,
    required String description,
    required int canBeRetailed,
    List<File>? productGalleries,
  }) async {
    //loading = true;
    try{
      if(await ProductService().createProduct(
        categoryId: categoryId,
        name: name,
        size: size,
        price: price,
        description: description,
        canBeRetailed: canBeRetailed,
        productGalleries: productGalleries,
      )) {
        //loading = false;
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

  bool checkIfUsed(String? value) {
    bool isUsed = _products.any(
            (element) => element.name.toLowerCase() == value?.toLowerCase()
    );
    return isUsed;
  }

  bool editCheckIfUsed(int idProductToEdit, String? value) {
    List<ProductModel> ignoredSelfProducts = _products.where(
        (product) => product.id != idProductToEdit
    ).toList();

    bool isUsed = ignoredSelfProducts.any(
                    (element) => element.name.toLowerCase() == value?.toLowerCase()
                  );
    return isUsed;
  }

  Future<bool> updateProduct({
    int id = 0,
    int? categoryId,
    String? productName,
    double? size,
    double? price,
    String? description,
    int? canBeRetailed,
  }) async {
    //loading = true;
    try{
      if(await ProductService().updateProduct(
        id: id,
        categoryId: categoryId,
        productName: productName,
        size: size,
        price: price,
        description: description,
        canBeRetailed: canBeRetailed,
      )){
        //loading = false;
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

  void setDefaultCanBeRetailed(int value) {
    selectedValue = value;
    notifyListeners();
  }

  Future<void> checkProductInTransaction({
    required int id
  }) async {
    try {
      _countProduct = await ProductService().productInTransaction(id: id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    print('produk di transaksi: $_countProduct');
  }

  Future<bool> updateActivationProduct({
    int id = 0,
    String stockStatus = '',
  }) async {
    //loading = true;
    try{
      if(await ProductService().updateActivationProduct(
        id: id,
        stockStatus: stockStatus,
      )){
        //loading = false;
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

  Future<bool> updateProductPrice({
    int id = 0,
    double price = 0,
  }) async {
    try{
      if(await ProductService().updateProductPrice(id: id, price: price)) {
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

  Future<bool> deleteProduct({
    int id = 0,
  }) async {
    try{
      if(await ProductService().deleteProduct(id: id)) {
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

  Future<void> pusherStock() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('stock-updated');

    channel.bind('App\\Events\\StockUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      var productIdToUpdate = int.parse(data['productId'].toString());

      _products.where(
              (product) => product.id == productIdToUpdate
      ).first.stock = data['stockQty'];
      notifyListeners();
    });
  }

  Future<void> pusherProductStatus() async {
    PusherClient pusher;
    Channel channel;
    pusher = PusherClient('2243680746c2e59ee156', PusherOptions(cluster: 'ap1'));

    channel = pusher.subscribe('product-status');

    channel.bind('App\\Events\\ProductStatusUpdated', (event) {
      print(event!.data);
      final data = jsonDecode(event.data!);

      //update data status sesuai dgn id yg dituju
      _products.where((e) => e.id == int.parse(data['productId'].toString())).first.stockStatus = data['productStatus'];
      notifyListeners();
    });
  }
}