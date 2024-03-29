import 'dart:convert';
import 'dart:io';
import 'package:budiberas_admin_9701/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:budiberas_admin_9701/constants.dart' as constants;

class ProductService{
  String baseUrl = constants.baseUrl;

  Future<List<ProductModel>> getProducts() async{
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
      List data = jsonDecode(response.body)['data'];

      List<ProductModel> products = [];

      for(var item in data) {
        products.add(ProductModel.fromJson(item));
      }

      return products;
    } else {
      throw Exception('Data produk gagal diambil!');
    }
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
    var url = '$baseUrl/product';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': token,
    };

    var body = {
      'category_id': categoryId.toString(),
      'product_name': name,
      'size': size.toString(),
      'price': price.toString(),
      'description': description,
      'can_be_retailed': canBeRetailed.toString(),
    };

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers.addAll(headers)
      ..fields.addAll(body);

    if(productGalleries != null) {
      for(int i=0; i < productGalleries.length; i++) {
        request.files.add(await http.MultipartFile.fromPath('productGalleries[]', productGalleries[i].path));
      }
    }

    print(request.fields);
    for(int i=0; i < request.files.length; i++) {
      print(request.files[i].filename);
    }

    var response = await request.send();

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data produk gagal ditambahkan');
    }
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
    var url = '$baseUrl/product/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'category_id': categoryId,
      'product_name': productName,
      'size': size,
      'price': price,
      'description': description,
      'can_be_retailed': canBeRetailed,
    });

    var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data produk gagal diperbarui');
    }
  }

  Future<bool> updateActivationProduct({
    int id = 0,
    String stockStatus = '',
  }) async {
    var url = '$baseUrl/statusProduct/$id';
    String token = await constants.getTokenAdmin();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'stock_status': stockStatus,
    });

    var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Status produk gagal diperbarui');
    }
  }

  Future<bool> updateProductPrice({
    int id = 0,
    double price = 0,
  }) async {
    var url = '$baseUrl/productPrice/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode({
      'price': price,
    });

    var response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Harga produk gagal diperbarui');
    }
  }

  Future<bool> deleteProduct({
    int id = 0,
  }) async {
    var url = '$baseUrl/product/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data produk gagal dihapus');
    }
  }

  Future<int> productInTransaction({
    required int id,
  }) async {
    var url = '$baseUrl/productInTransaction/$id';
    String token = await constants.getTokenAdmin();

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };

    var response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    return int.parse(response.body);
  }
}