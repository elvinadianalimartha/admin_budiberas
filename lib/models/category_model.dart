class CategoryModel{
  late int id;
  late String category_name;

  CategoryModel({required this.id, required this.category_name});

  CategoryModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    category_name = json['category_name'];
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'category_name': category_name,
    };
  }
}