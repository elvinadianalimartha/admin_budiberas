class ReportMonthlyModel{
  late String categoryName;
  late int qtySold;
  late int totalSold;
  late List<DetailReportMonthlyModel> detailProduct;

  ReportMonthlyModel({
    required this.categoryName,
    required this.qtySold,
    required this.totalSold,
    required this.detailProduct,
  });

  ReportMonthlyModel.fromJson(Map<String, dynamic> json){
    categoryName = json['category_name'];
    qtySold = int.parse(json['qty_sold'].toString());
    totalSold = int.parse(json['total_sold'].toString());
    detailProduct = json['detail_product']
        .map<DetailReportMonthlyModel>((detail) => DetailReportMonthlyModel.fromJson(detail)).toList();
  }
}

class DetailReportMonthlyModel{
  late int id;
  late String productName;
  late int qtySold;
  late int totalSold;

  DetailReportMonthlyModel({
    required this.id,
    required this.productName,
    required this.qtySold,
    required this.totalSold,
  });

  DetailReportMonthlyModel.fromJson(Map<String, dynamic> json){
    id = int.parse(json['id'].toString());
    productName = json['product_name'];
    qtySold = int.parse(json['qty_sold'].toString());
    totalSold = int.parse(json['total_sold'].toString());
  }
}