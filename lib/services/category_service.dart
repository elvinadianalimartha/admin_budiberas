import 'dart:convert';
import 'package:budiberas_admin_9701/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:budiberas_admin_9701/constants.dart' as constants;

class CategoryService{
  String baseUrl = constants.baseUrl;

  Future<List<CategoryModel>> getCategories() async{
    var url = '$baseUrl/categories';
    var headers = {'Content-Type': 'application/json'};
    
    var response = await http.get(
      Uri.parse(url),
      headers: headers
    );

    print(response.body);

    if(response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      List<CategoryModel> categories = [];
      
      for(var item in data) {
        categories.add(CategoryModel.fromJson(item));
      }

      return categories;
    } else {
      throw Exception('Data kategori gagal diambil!');
    }
  }

  Future<bool> createCategory({
    String category_name = '',
  }) async {
    var url = '$baseUrl/category';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'category_name': category_name,
    });

    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data kategori gagal ditambahkan');
    }
  }

  Future<bool> updateCategory({
    int id = 0,
    String category_name = '',
  }) async {
    var url = '$baseUrl/category/$id';
    var headers = {'Content-Type': 'application/json'};
    var body = jsonEncode({
      'category_name': category_name,
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
      throw Exception('Data kategori gagal diperbarui');
    }
  }

  Future<bool> deleteCategory({
    int id = 0,
  }) async {
    var url = '$baseUrl/category/$id';
    var headers = {'Content-Type': 'application/json'};

    var response = await http.delete(
        Uri.parse(url),
        headers: headers,
    );

    print(response.body);

    if(response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Data kategori gagal dihapus');
    }
  }
}