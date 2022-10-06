import 'package:budiberas_admin_9701/models/transaction_model.dart';
import 'package:budiberas_admin_9701/providers/transaction_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/trans_update_button.dart';
import 'package:flutter/material.dart';

import '../../../services/notification_service.dart';
import '../../../theme.dart';

class UpdateTransactionButton {
  late TransactionProvider transactionProvider;
  late TransactionModel transactions;
  late BuildContext context;

  UpdateTransactionButton({
    required this.transactionProvider,
    required this.transactions,
    required this.context
  });

  handleUpdateTransactionStatus({
    required String status,
    required String notificationTitle,
    String? notificationBody,
  }) async {
    if(await transactionProvider.updateStatusTransaction(id: transactions.id, newStatus: status)) {
      NotificationService().sendFcm(
          title: notificationTitle,
          body: notificationBody,
          fcmToken: transactions.fcmToken!
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Status transaksi berhasil diperbarui'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Status transaksi gagal diperbarui'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
      );
    }
  }

  transUpdateBtn({
    required String status,
    required String shippingType,
    required double fontSize,
  }) {
    switch(status.toLowerCase()) {
      case 'success': //pembayaran sukses
        return TransUpdateBtn(
          fontSize: fontSize,
          text: 'Konfirmasi',
          onClick: () {
            //updateStatus to processed
            handleUpdateTransactionStatus(
                status: 'processed',
                notificationTitle: 'Pesanan ${transactions.invoiceCode} sedang diproses'
            );
          },
        );
      case 'processed':
        return TransUpdateBtn(
          fontSize: fontSize,
          text: shippingType.toLowerCase() == 'pesan antar' ? 'Antar' : 'Siap Diambil', //tergantung shippingTypenya
          onClick: () {
            //updateStatus to delivered or ready to take
            handleUpdateTransactionStatus(
                status: shippingType.toLowerCase() == 'pesan antar' ? 'delivered' : 'ready to take',
                notificationTitle: shippingType.toLowerCase() == 'pesan antar'
                    ? 'Pesanan ${transactions.invoiceCode} sedang diantar'
                    : 'Pesanan ${transactions.invoiceCode} siap diambil sekarang',
                notificationBody: shippingType.toLowerCase() == 'pesan antar'
                    ? null
                    : 'Silakan datang ke Toko Sembako Budi Beras'
            );
          },
        );
      case 'delivered':
        return TransUpdateBtn(
          fontSize: fontSize,
          text: 'Tiba di Tujuan',
          onClick: () {
            //updateStatus to arrived
            handleUpdateTransactionStatus(
                status: 'arrived',
                notificationTitle: 'Pesanan ${transactions.invoiceCode} sudah tiba di tujuan',
                notificationBody: 'Selesaikan pesanan jika sudah menerimanya 😄'
            );
          },
        );
      default:
        return const SizedBox();
    }
  }
}