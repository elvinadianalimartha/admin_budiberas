class ReportDailyModel{
  //late int omzet;
  late String productName;
  late int qtySold;
  late int totalSold;
  //String? photoUrl;

  ReportDailyModel({
    //required this.omzet,
    required this.productName,
    required this.qtySold,
    required this.totalSold,
    //this.photoUrl
  });

  ReportDailyModel.fromJson(Map<String, dynamic> json){
    //omzet = int.parse(json['omzet'].toString());
    productName = json['product_name'];
    qtySold = int.parse(json['qty_sold'].toString());
    totalSold = int.parse(json['total_sold'].toString());
    //photoUrl = json['detailReport']['photo']['photo_url'];
  }
}