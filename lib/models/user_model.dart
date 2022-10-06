class UserModel{
  late int id;
  String? name, email, token, fcmToken;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.token,
    this.fcmToken
  });

  UserModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    email = json['email'];
    token = json['token'];
    fcmToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'fcm_token': fcmToken
    };
  }
}