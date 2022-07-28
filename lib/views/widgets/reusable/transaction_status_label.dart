import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class TransactionStatusLabel {
  Widget redLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffffdeeb).withOpacity(0.5),
      ),
      child: Text(
        text,
        style: alertTextStyle.copyWith(fontSize: 11)
      ),
    );
  }
  
  Widget yellowLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffFFEDCB).withOpacity(0.5),
      ),
      child: Text(
        text,
        style: yellowTextStyle.copyWith(fontSize: 11)
      ),
    );
  }
  
  Widget greenLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: fourthColor.withOpacity(0.5),
      ),
      child: Text(
        text,
        style: priceTextStyle.copyWith(fontSize: 11),
      ),
    );
  }

  Widget blueLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.lightBlueAccent.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: blueTextStyle.copyWith(fontSize: 12),
      ),
    );
  }

  Widget greyLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: secondaryTextColor.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: greyTextStyle.copyWith(fontSize: 11),
      ),
    );
  }

  labellingStatus(String status) {
    switch(status.toLowerCase()) {
      case 'cancelled':
        return redLabel('Pesanan Dibatalkan');
      case 'pending':
        return yellowLabel('Menunggu Pembayaran');
      case 'success': //pembayaran sukses
        return yellowLabel('Menunggu Konfirmasi');
      case 'processed':
        return yellowLabel('Diproses');
      case 'delivered':
        return yellowLabel('Sedang Diantar');
      case 'arrived':
        return blueLabel('Tiba di Tujuan');
      case 'ready to take':
        return blueLabel('Siap Diambil');
      case 'done':
        return greenLabel('Selesai');
      default:
        return greyLabel(status);
    }
  }
}
