class OutStockModel{
  late int id;
  late String product;
  String? isDeletedProduct;
  late DateTime outDate;
  late String outTime;
  late int quantity;
  late String outStatus;

  OutStockModel({
    required this.id,
    required this.product,
    this.isDeletedProduct,
    required this.outDate,
    required this.outTime,
    required this.quantity,
    required this.outStatus
  });

  OutStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product']['product_name'];
    isDeletedProduct = json['product']['deleted_at'];
    outDate = DateTime.tryParse(json['out_date'])!;
    outTime = json['out_time'];
    quantity = json['quantity'];
    outStatus = json['out_status'];
  }
}