import 'dart:convert';

import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class SuggestionProductService {
  String baseUrl = constants.baseUrl;

  Future<List<ProductModel>> getSuggestionProduct(String query) async{
    var url = '$baseUrl/products';
    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List products = jsonDecode(response.body)['data'];

      return products.map((e) => ProductModel.fromJson(e)).where((product) {
        final lowerName = product.name.toLowerCase();
        final lowerQuery = query.toLowerCase();

        return lowerName.contains(lowerQuery);
      }).toList();
    } else {
      throw Exception('Data produk gagal diambil!');
    }
  }

  Future<List<ProductModel>> getAvailableStockProduct(String searchQuery) async{
    var url = '$baseUrl/availableStockProduct';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List products = jsonDecode(response.body)['data'];

      return products.map((e) => ProductModel.fromJson(e)).where((product) {
        final lowerName = product.name.toLowerCase();
        final lowerQuery = searchQuery.toLowerCase();

        return lowerName.contains(lowerQuery);
      }).toList();
    } else {
      throw Exception('Data produk yang stoknya lebih dari 0 gagal diambil!');
    }
  }

  Future<List<ProductModel>> getCanBeRetailedProduct(String query) async{
    var url = '$baseUrl/retailedProduct';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List products = jsonDecode(response.body)['data'];

      return products.map((e) => ProductModel.fromJson(e)).where((product) {
        final lowerName = product.name.toLowerCase();
        final lowerQuery = query.toLowerCase();

        return lowerName.contains(lowerQuery);
      }).toList();
    } else {
      throw Exception('Data produk yang bisa diecer gagal diambil!');
    }
  }

  Future<List<ProductModel>> getDestinationProduct({
    String? query,
    required int sourceProductId,
  }) async{
    var url = '$baseUrl/destinationProduct/$sourceProductId';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Connection': 'keep-alive',
      'Authorization': token,
    };

    var response = await http.get(
        Uri.parse(url),
        headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List products = jsonDecode(response.body)['data'];

      return products.map((e) => ProductModel.fromJson(e)).where((product) {
        final lowerName = product.name.toLowerCase();
        final lowerQuery = query!.toLowerCase();

        return lowerName.contains(lowerQuery);
      }).toList();
    } else {
      throw Exception('Data produk tujuan gagal diambil!');
    }
  }
}