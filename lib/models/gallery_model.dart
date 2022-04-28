class GalleryModel{
  int? id;
  String? url;
  String? tempId;

  GalleryModel({this.id, this.url, this.tempId});

  GalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['photo_url'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo_url': url,
    };
  }
}