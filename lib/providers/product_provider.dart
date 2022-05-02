import 'dart:io';

import 'package:budiberas_admin_9701/models/product_model.dart';
import 'package:budiberas_admin_9701/services/product_service.dart';
import 'package:flutter/cupertino.dart';

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

  void disposeValues() {
    _searchQuery = '';
    _products = [];
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
        // loading = false;
        // notifyListeners();
        return true;
      } else {
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }

// Future<bool> updateCategory({
//   int id = 0,
//   String category_name = '',
// }) async {
//   loading = true;
//   try{
//     if(await CategoryService().updateCategory(id: id, category_name: category_name)) {
//       loading = false;
//       notifyListeners();
//       return true;
//     } else {
//       return false;
//     }
//   }catch(e) {
//     print(e);
//     return false;
//   }
// }
//
// Future<bool> deleteCategory({
//   int id = 0,
// }) async {
//   loading = true;
//   try{
//     if(await CategoryService().deleteCategory(id: id)) {
//       loading = false;
//       notifyListeners();
//       return true;
//     } else {
//       return false;
//     }
//   }catch(e) {
//     print(e);
//     return false;
//   }
// }
}