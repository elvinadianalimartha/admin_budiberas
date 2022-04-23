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
      List data = jsonDecode(response.body)['data']['data'];
      List<CategoryModel> categories = [];
      
      for(var item in data) {
        categories.add(CategoryModel.fromJson(item));
      }

      return categories;
    } else {
      throw Exception('Data kategori gagal diambil!');
    }
  }
}