import 'package:budiberas_admin_9701/models/category_model.dart';
import 'package:flutter/cupertino.dart';

import '../services/category_service.dart';

class CategoryProvider with ChangeNotifier{
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  set categories(List<CategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  Future<void> getCategories() async {
    try{
      List<CategoryModel> categories = await CategoryService().getCategories();
      _categories = categories; //_categories akan diisi dengan data categories yg didapat dr fungsi getCategories backend
    } catch(e) {
      print(e);
    }
  }
}