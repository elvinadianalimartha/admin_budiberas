import 'package:budiberas_admin_9701/models/product_model.dart';

class MessageDetailModel {
  late String id;

  //pesan dan pengirimnya
  late String message;

  //utk mengetahui chat berasal dr pelanggan atau pemilik
  late bool isFromUser;

  //utk menautkan produk yg ingin ditanyakan
  ProductModel? product;

  //utk menautkan gambar
  String? imageUrl;

  late DateTime createdAt;
  DateTime? updatedAt;
  late bool isRead;

  MessageDetailModel({
    required this.id,
    required this.message,
    required this.isFromUser,
    this.product,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    required this.isRead,
  });

  MessageDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    isFromUser = json['isFromUser'];

    product = json['product'].isEmpty
        ? UninitializedProductModel()
        : ProductModel.fromJsonFirebase(json['product']);
    imageUrl = json['imageUrl'];

    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    isRead = json['isRead'];
  }
}