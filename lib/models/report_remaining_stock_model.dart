class ReportRemainingStockModel{
  late int productId;
  late String productName;
  late int initStock;
  late int endStock;
  late DetailRemainingStockModel detail;

  ReportRemainingStockModel({
    required this.productId,
    required this.productName,
    required this.initStock,
    required this.endStock,
    required this.detail,
  });

  ReportRemainingStockModel.fromJson(Map<String, dynamic> json){
    productId = json['product_id'];
    productName = json['product_name'];
    initStock = int.parse(json['init_stock'].toString());
    endStock = int.parse(json['end_stock'].toString());
    detail = DetailRemainingStockModel.fromJson(json['detail']);
  }
}

class DetailRemainingStockModel{
  late int qtyTransaction;
  late int qtyIncomingStock;
  late int qtyOutStock;
  late int qtyShiftSource;
  late int qtyShiftDestination;

  DetailRemainingStockModel({
    required this.qtyTransaction,
    required this.qtyIncomingStock,
    required this.qtyOutStock,
    required this.qtyShiftSource,
    required this.qtyShiftDestination
  });

  DetailRemainingStockModel.fromJson(Map<String, dynamic> json){
    qtyTransaction = int.parse(json['endTrans'].toString());
    qtyIncomingStock = int.parse(json['endIncoming'].toString());
    qtyOutStock = int.parse(json['endOut'].toString());
    qtyShiftSource = int.parse(json['endShiftSource'].toString());
    qtyShiftDestination = int.parse(json['endShiftDest'].toString());
  }
}