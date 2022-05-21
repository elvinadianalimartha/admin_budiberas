class GalleryModel{
  int? id;
  String? url;
  String? tempId;
  int? productId;

  GalleryModel({this.id, this.url, this.tempId, this.productId});

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['photo_url'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo_url': url,
      'product_id': productId,
    };
  }
}