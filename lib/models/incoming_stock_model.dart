import 'package:budiberas_admin_9701/models/product_model.dart';
import 'package:flutter/material.dart';

class IncomingStockModel{
  late int id;
  late String product;
  late DateTime incomingDate;
  late String incomingTime;
  late int quantity;
  late String incomingStatus;

  IncomingStockModel({
    required this.id,
    required this.product,
    required this.incomingDate,
    required this.incomingTime,
    required this.quantity,
    required this.incomingStatus
  });

  IncomingStockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product']['product_name'];
    incomingDate = DateTime.tryParse(json['incoming_date'])!;
    incomingTime = json['incoming_time'];
    quantity = json['quantity'];
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