import 'package:budiberas_admin_9701/models/shift_destination_model.dart';

class ShiftStockModel{
  late int id;
  late String sourceProductName;
  late double sourceProductSize;
  String? isDeletedSourceProduct;
  late DateTime shiftingDate;
  late String shiftingTime;
  late int quantity;
  late ShiftStockDestinationModel shiftStockDestination;

  ShiftStockModel({
    required this.id,
    required this.sourceProductName,
    required this.sourceProductSize,
    this.isDeletedSourceProduct,
    required this.shiftingDate,
    required this.shiftingTime,
    required this.quantity,
    required this.shiftStockDestination,
  });

  ShiftStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sourceProductName = json['product']['product_name'];
    sourceProductSize = double.parse(json['product']['size'].toString());
    isDeletedSourceProduct = json['product']['deleted_at'];
    shiftingDate = DateTime.tryParse(json['shifting_date'])!;
    shiftingTime = json['shifting_time'];
    quantity = int.parse(json['quantity'].toString());
    shiftStockDestination = ShiftStockDestinationModel.fromJson(json['shift_stock_destination']);
  }
}