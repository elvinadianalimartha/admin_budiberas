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

      return products.map((e) => ProductModel.fromJson(e)).where((user) {
        final lowerName = user.name.toLowerCase();
        final lowerQuery = query.toLowerCase();

        return lowerName.contains(lowerQuery);
      }).toList();

      // return products;
    } else {
      throw Exception('Data produk gagal diambil!');
    }
  }

  // Future<List<ProductModel>> getAvailableStockProduct(String searchQuery) async{
  //   var url = '$baseUrl/availableStockProduct';
  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Connection': 'keep-alive',
  //   };
  //
  //   Map<String, dynamic> qParams = {
  //     'query': searchQuery,
  //   };
  //
  //   var response = await http.get(
  //       Uri.parse(url).replace(queryParameters: qParams),
  //       headers: headers
  //   );
  //
  //   print(response.body);
  //
  //   if(response.statusCode == 200) {
  //     List data = jsonDecode(response.body)['data'];
  //
  //     List<ProductModel> products = [];
  //
  //     for(var item in data) {
  //       products.add(ProductModel.fromJson(item));
  //     }
  //     return products;
  //
  //     // return products.map((e) => ProductModel.fromJson(e)).where((user) {
  //     //   final lowerName = user.name.toLowerCase();
  //     //   final lowerQuery = query.toLowerCase();
  //     //
  //     //   return lowerName.contains(lowerQuery);
  //     // }).toList();
  //
  //   } else {
  //     throw Exception('Data produk yang stoknya lebih dari 0 gagal diambil!');
  //   }
  // }

  Future<List<ProductModel>> getAvailableStockProduct(String searchQuery) async{
    var url = '$baseUrl/availableStockProduct';
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

      return products.map((e) => ProductModel.fromJson(e)).where((user) {
        final lowerName = user.name.toLowerCase();
        final lowerQuery = searchQuery.toLowerCase();

        return lowerName.contains(lowerQuery);
      }).toList();

    } else {
      throw Exception('Data produk yang stoknya lebih dari 0 gagal diambil!');
    }
  }
}