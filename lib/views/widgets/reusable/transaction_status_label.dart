import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class TransactionStatusLabel {
  Widget redLabel({
    required String text,
    required double fontSize
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffffdeeb).withOpacity(0.5),
      ),
      child: Text(
        text,
        style: alertTextStyle.copyWith(fontSize: fontSize)
      ),
    );
  }
  
  Widget yellowLabel({
    required String text,
    required double fontSize
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color(0xffFFEDCB).withOpacity(0.5),
      ),
      child: Text(
        text,
        style: yellowTextStyle.copyWith(fontSize: fontSize)
      ),
    );
  }
  
  Widget greenLabel({
    required String text,
    required double fontSize
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: fourthColor.withOpacity(0.5),
      ),
      child: Text(
        text,
        style: priceTextStyle.copyWith(fontSize: fontSize),
      ),
    );
  }

  Widget blueLabel({
    required String text,
    required double fontSize
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.lightBlueAccent.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: blueTextStyle.copyWith(fontSize: fontSize),
      ),
    );
  }

  Widget greyLabel({
    required String text,
    required double fontSize
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: secondaryTextColor.withOpacity(0.2),
      ),
      child: Text(
        text,
        style: greyTextStyle.copyWith(fontSize: fontSize),
      ),
    );
  }

  labellingStatus({
    required String status,
    required double fontSize
  }) {
    switch(status.toLowerCase()) {
      case 'cancelled':
        return redLabel(text: 'Pesanan Dibatalkan', fontSize: fontSize);
      case 'pending':
        return yellowLabel(text: 'Menunggu Pembayaran', fontSize: fontSize);
      case 'success': //pembayaran sukses
        return yellowLabel(text: 'Menunggu Konfirmasi', fontSize: fontSize);
      case 'processed':
        return yellowLabel(text: 'Diproses', fontSize: fontSize);
      case 'delivered':
        return yellowLabel(text: 'Sedang Diantar', fontSize: fontSize);
      case 'arrived':
        return blueLabel(text: 'Tiba di Tujuan', fontSize: fontSize);
      case 'ready to take':
        return blueLabel(text: 'Siap Diambil', fontSize: fontSize);
      case 'done':
        return greenLabel(text: 'Selesai', fontSize: fontSize);
      default:
        return greyLabel(text: status, fontSize: fontSize);
    }
  }
}
