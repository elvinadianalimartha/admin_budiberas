import 'dart:convert';
import 'package:budiberas_admin_9701/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:budiberas_admin_9701/constants.dart' as constants;

class ProductService{
  String baseUrl = constants.baseUrl;

  Future<List<ProductModel>> getProducts() async{
    var url = '$baseUrl/products';
    var headers = {'Content-Type': 'application/json'};
    
    var response = await http.get(
      Uri.parse(url),
      headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data']['data'];
      List<ProductModel> products = [];
      
      for(var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Data produk gagal diambil!');
    }
  }

  // Future<bool> createProduct({
  //   String category_name = '',
  // }) async {
  //   var url = '$baseUrl/product';
  //   var headers = {'Content-Type': 'application/json'};
  //   var body = jsonEncode({
  //     'category_name': category_name,
  //   });
  //
  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: headers,
  //     body: body
  //   );
  //
  //   print(response.body);
  //
  //   if(response.statusCode == 200) {
  //     return true;
  //   } else {
  //     throw Exception('Data produk gagal ditambahkan');
  //   }
  // }

  // Future<bool> updateCategory({
  //   int id = 0,
  //   String category_name = '',
  // }) async {
  //   var url = '$baseUrl/category/$id';
  //   var headers = {'Content-Type': 'application/json'};
  //   var body = jsonEncode({
  //     'category_name': category_name,
  //   });
  //
  //   var response = await http.put(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body
  //   );
  //
  //   print(response.body);
  //
  //   if(response.statusCode == 200) {
  //     return true;
  //   } else {
  //     throw Exception('Data kategori gagal ditambahkan');
  //   }
  // }
  //
  // Future<bool> deleteCategory({
  //   int id = 0,
  // }) async {
  //   var url = '$baseUrl/category/$id';
  //   var headers = {'Content-Type': 'application/json'};
  //
  //   var response = await http.delete(
  //       Uri.parse(url),
  //       headers: headers,
  //   );
  //
  //   print(response.body);
  //
  //   if(response.statusCode == 200) {
  //     return true;
  //   } else {
  //     throw Exception('Data kategori gagal dihapus');
  //   }
  // }
}