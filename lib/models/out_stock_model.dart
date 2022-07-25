class OutStockModel{
  late int id;
  late String productName;
  late int productStock;
  String? isDeletedProduct;
  late DateTime outDate;
  late String outTime;
  late int quantity;
  late String outStatus;

  OutStockModel({
    required this.id,
    required this.productName,
    required this.productStock,
    this.isDeletedProduct,
    required this.outDate,
    required this.outTime,
    required this.quantity,
    required this.outStatus
  });

  OutStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product']['product_name'];
    productStock = int.parse(json['product']['stock'].toString());
    isDeletedProduct = json['product']['deleted_at'];
    outDate = DateTime.tryParse(json['out_date'])!;
    outTime = json['out_time'];
    quantity = int.parse(json['quantity'].toString());
    outStatus = json['out_status'];
  }
}