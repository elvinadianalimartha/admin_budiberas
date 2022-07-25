class IncomingStockModel{
  late int id;
  late String product;
  String? isDeletedProduct;
  late DateTime incomingDate;
  late String incomingTime;
  late int quantity;
  late String incomingStatus;

  IncomingStockModel({
    required this.id,
    required this.product,
    this.isDeletedProduct,
    required this.incomingDate,
    required this.incomingTime,
    required this.quantity,
    required this.incomingStatus
  });

  IncomingStockModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    product = json['product']['product_name'];
    isDeletedProduct = json['product']['deleted_at'];
    incomingDate = DateTime.tryParse(json['incoming_date'])!;
    incomingTime = json['incoming_time'];
    quantity = int.parse(json['quantity'].toString());
    incomingStatus = json['incoming_status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'incoming_date': incomingDate,
      'incoming_time': incomingTime,
      'quantity': quantity,
      'incoming_status': incomingStatus,
    };
  }
}