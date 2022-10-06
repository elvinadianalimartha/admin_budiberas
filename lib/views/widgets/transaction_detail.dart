import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/image_builder.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/transaction_detail_widget.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/transaction_status_label.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/update_transaction_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../theme.dart';

class TransactionDetail extends StatefulWidget {
  final TransactionModel transactions;

  const TransactionDetail({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<TransactionProvider>(context, listen: false).pusherTransactionStatus();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    String formattedPaymentMethod = widget.transactions.paymentMethod.replaceAll('_', ' ').toUpperCase();

    double totalPriceProduct = widget.transactions.totalPrice - widget.transactions.shippingRate;
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(widget.transactions.checkoutDate);

    Widget header() {
      return Consumer<TransactionProvider>(
          builder: (context, transProv, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transactions.invoiceCode,
                    style: primaryTextStyle.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    'Tanggal pembelian: ' + formattedDate + ' | ' + widget.transactions.checkoutTime,
                    style: greyTextStyle.copyWith(fontSize: 13),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Divider(thickness: 1,),
                  ),
                  //jika mau connect ke pusher, harus pakai consumer (atau set state) spy bisa langsung terubah datanya
                  TransactionStatusLabel().labellingStatus(
                      status: transProv.transactions.where((e) => e.id == widget.transactions.id).first.transactionStatus,
                      fontSize: 13,
                  ),
                ],
              ),
            );
          }
      );
    }

    Widget deliveryDetail() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pesanan dikirimkan kepada: ',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 4,),
            Text(
              widget.transactions.orderReceiver!,
              style: primaryTextStyle.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4,),
            Text(
                widget.transactions.phoneNumber!,
                style: greyTextStyle.copyWith(fontSize: 13)
            ),
            const SizedBox(height: 4,),
            RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.transactions.address,
                        style: greyTextStyle.copyWith(fontSize: 13),
                      ),
                      widget.transactions.detailAddress != '' && widget.transactions.detailAddress != null
                          ? TextSpan(
                        text: ' (${widget.transactions.detailAddress})',
                        style: greyTextStyle.copyWith(fontSize: 13),
                      )
                          : const TextSpan()
                    ]
                )
            )
          ],
        ),
      );
    }

    Widget pickupCode() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: formColor
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      'Nama penerima',
                      style: primaryTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      ':\t\t${widget.transactions.userName}',
                      style: primaryTextStyle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: Text(
                      'Kode pengambilan',
                      style: primaryTextStyle.copyWith(fontSize: 14),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      ':\t ${widget.transactions.pickupCode}',
                      style: primaryTextStyle.copyWith(fontSize: 14, letterSpacing: 1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget notePickupWhenDone() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Text(
          'Pesanan sudah diambil di toko 👍',
          style: primaryTextStyle,
        ),
      );
    }

    Widget orderList() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Daftar Pesanan',
                style: primaryTextStyle.copyWith(fontWeight: semiBold),
              ),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(), //disable scrolling
                padding: const EdgeInsets.only(bottom: 0),
                shrinkWrap: true,
                itemCount: widget.transactions.details.length,
                itemBuilder: (context, index) {
                  return OrderDetailWidget(
                    photo: widget.transactions.details[index].product.galleries.isNotEmpty
                        ? ImageBuilderWidgets().imageFromNetwork(
                        imageUrl: widget.transactions.details[index].product.galleries[0].url!,
                        width: 60,
                        height: 60,
                        sizeIconError: 60
                    )
                        : ImageBuilderWidgets().blankImage(sizeIcon: 60),
                    productName: widget.transactions.details[index].product.productName,
                    quantity: '${widget.transactions.details[index].quantity} barang',
                    subtotal: 'Rp ' + formatter.format(widget.transactions.details[index].subtotal),
                    orderNotes: widget.transactions.details[index].orderNotes,
                  );
                }
            )
          ],
        ),
      );
    }

    Widget billing() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8,),
            BillingDetailWidget(
                totalPrice: 'Rp ' + formatter.format(totalPriceProduct),
                shippingRate: 'Rp ' + formatter.format(widget.transactions.shippingRate)
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(thickness: 1,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Pembayaran',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                Text(
                  'Rp ' + formatter.format(widget.transactions.totalPrice),
                  style: priceTextStyle.copyWith(fontWeight: semiBold),
                )
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Metode Bayar',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                const SizedBox(width: 20,),
                Flexible(
                  child: Text(
                    widget.transactions.bankName == null
                        ? formattedPaymentMethod
                        : formattedPaymentMethod + ' ' + widget.transactions.bankName!.toUpperCase(),
                    style: blueTextStyle.copyWith(fontWeight: semiBold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget transUpdateField() {
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow> [
                BoxShadow(color: secondaryTextColor.withOpacity(0.2), blurRadius: 20.0),
              ]
          ),
          padding: const EdgeInsets.all(20),
          child: UpdateTransactionButton(
              transactionProvider: context.read<TransactionProvider>(),
              context: context,
              transactions: widget.transactions
          ).transUpdateBtn(
            status: widget.transactions.transactionStatus,
            shippingType: widget.transactions.shippingType,
            fontSize: 15
          )
      );
    }

    Widget content() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            widget.transactions.shippingType.toLowerCase() == 'pesan antar'
              ? deliveryDetail()
              : pickupCode(),
            widget.transactions.shippingType.toLowerCase() == 'ambil mandiri' && widget.transactions.transactionStatus == 'done'
              ? notePickupWhenDone()
              : const SizedBox(),
            const Divider(thickness: 2,),
            orderList(),
            const Divider(thickness: 2,),
            billing(),
            const SizedBox(height: 20,),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Detail Pesanan'),
      body: content(),
      bottomNavigationBar: widget.transactions.transactionStatus.toLowerCase() != 'done'
          ? transUpdateField()
          : const SizedBox()
    );
  }
}