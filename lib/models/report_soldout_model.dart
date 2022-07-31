class ReportSoldOutModel{
  late String productName;
  String? photoUrl;

  ReportSoldOutModel({
    required this.productName,
    this.photoUrl
  });

  ReportSoldOutModel.fromJson(Map<String, dynamic> json){
    productName = json['product_name'];
    photoUrl = json['photo_url'];
  }
}