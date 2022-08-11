class UserModel{
  late int id;
  String? name, email, token;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.token,
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}