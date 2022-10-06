import 'package:budiberas_admin_9701/services/notification_service.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/image_builder.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/trans_update_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/transaction_status_label.dart';
import 'package:budiberas_admin_9701/views/widgets/transaction_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transactions;
  final TransactionProvider transactionProvider;

  const TransactionCard({
    Key? key,
    required this.transactions,
    required this.transactionProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    //String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(transactions.checkoutDate);

    Widget shippingAddress() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transactions.orderReceiver!,
            style: greyTextStyle.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: thirdColor, size: 16,),
              const SizedBox(width: 4,),
              Flexible(
                child: Text(
                  transactions.address!,
                  style: greyTextStyle.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          )
        ],
      );
    }

    Widget pickupCode() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transactions.userName,
            style: greyTextStyle.copyWith(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Kode pengambilan : ${transactions.pickupCode}',
            style: greyTextStyle.copyWith(fontSize: 12),
            maxLines: null,
          ),
        ],
      );
    }

    Widget header() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  transactions.invoiceCode,
                  style: primaryTextStyle.copyWith(fontSize: 12),
                ),
              ),
              const SizedBox(width: 12,),
              TransactionStatusLabel().labellingStatus(status: transactions.transactionStatus, fontSize: 11.5),
            ],
          ),
          transactions.shippingType.toLowerCase() == 'pesan antar'
            ? shippingAddress()
            : pickupCode(),
          const Divider(thickness: 0.8,),
        ],
      );
    }

    Widget content() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: transactions.details[0].product.galleries.isNotEmpty
                        ? ImageBuilderWidgets().imageFromNetwork(
                        imageUrl: transactions.details[0].product.galleries[0]
                            .url!,
                        width: 60,
                        height: 60,
                        sizeIconError: 60
                    )
                        : ImageBuilderWidgets().blankImage(sizeIcon: 60)
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactions.details[0].product.productName,
                        style: primaryTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        '${transactions.details[0].quantity} barang',
                        style: greyTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8,),
                    ],
                  ),
                ),
              ],
            ),
            transactions.countRemainingDetails == 0
            ? const SizedBox()
            : Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '+ ' + transactions.countRemainingDetails.toString() +
                    ' produk lainnya',
                style: primaryTextStyle,
              ),
            )
          ],
        ),
      );
    }

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

    transUpdateBtn(String status, String shippingType) {
      switch(status.toLowerCase()) {
        case 'success': //pembayaran sukses
          return TransUpdateBtn(
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

    Widget footer() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              'Total: Rp ' + formatter.format(transactions.totalPrice),
              style: priceTextStyle,
            ),
          ),
          const SizedBox(width: 20,),
          transUpdateBtn(transactions.transactionStatus, transactions.shippingType),
        ],
      );
    }

    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionDetail(transactions: transactions,)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(
          bottom: 20,
          left: 20,
          right: 20,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: secondaryTextColor.withOpacity(0.8), width: 0.5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            content(),
            footer(),
          ],
        ),
      ),
    );
  }
}
