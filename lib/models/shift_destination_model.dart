class ShiftStockDestinationModel{
  late int id;
  late String destProductName;
  late String? isDeletedDestProduct;
  late int qtyDest;

  ShiftStockDestinationModel({
    required this.id,
    required this.destProductName,
    this.isDeletedDestProduct,
    required this.qtyDest,
  });

  ShiftStockDestinationModel.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    destProductName = json['product']['product_name'];
    isDeletedDestProduct = json['product']['deleted_at'];
    qtyDest = json['quantity'];
  }
}