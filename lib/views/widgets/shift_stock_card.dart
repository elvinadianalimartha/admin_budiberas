import 'package:budiberas_admin_9701/providers/shifting_stock_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/cancel_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/table_data_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/shift_stock_model.dart';

class ShiftStockCard extends StatelessWidget {
  final ShiftStockModel shiftStocks;
  final ShiftingStockProvider shiftingStockProvider;

  const ShiftStockCard({
    Key? key,
    required this.shiftStocks,
    required this.shiftingStockProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(shiftStocks.shiftingDate);

    handleCancelShifting() async{
      if(await shiftingStockProvider.cancelShiftStock(id: shiftStocks.id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pengalihan berhasil dibatalkan'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          )
        );
        shiftingStockProvider.getShiftStocks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pengalihan gagal dibatalkan'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          )
        );
      }
    }

    Future<void> areYouSureDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
            child: AlertDialog(
              insetPadding: const EdgeInsets.all(40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffffdeeb),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Icon(Icons.question_mark, size: 30, color: alertColor,)),
                    const SizedBox(height: 12,),
                    Text(
                      'Apakah Anda yakin?',
                      style: primaryTextStyle, textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10,),
                    RichText(text:
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Dengan membatalkan pengalihan ini, stok ',
                            style: secondaryTextStyle,
                          ),
                          TextSpan(
                            text: '${shiftStocks.sourceProductName} '
                                'akan kembali bertambah ',
                            style: secondaryTextStyle.copyWith(
                              fontWeight: semiBold,
                            )
                          ),
                          TextSpan(
                            text: '${shiftStocks.quantity.toString()} buah',
                            style: priceTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          )
                        ]
                      ),
                    ),
                    const SizedBox(height: 10,),
                    RichText(text:
                    TextSpan(
                        children: [
                          TextSpan(
                            text: 'Sedangkan stok ',
                            style: secondaryTextStyle,
                          ),
                          TextSpan(
                            text: '${shiftStocks.shiftStockDestination.destProductName} '
                                'akan berkurang ',
                            style: secondaryTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          ),
                          TextSpan(
                            text: '${shiftStocks.shiftStockDestination.qtyDest.toString()} buah',
                            style: priceTextStyle.copyWith(
                              fontWeight: semiBold,
                            ),
                          )
                        ]
                      ),
                    ),
                    SizedBox(height: defaultMargin,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CancelButton(
                          text: 'Tidak',
                          onClick: () {
                            Navigator.pop(context);
                          },
                        ),
                        DoneButton(
                          text: 'Ya, batalkan',
                          onClick: () {
                            handleCancelShifting();
                          },
                        )
                      ]
                    )
                  ],
                ),
              ),
            ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: secondaryTextColor.withOpacity(0.8),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableDataWidget(
              widthTitleBox: 150,
              title: 'Waktu pengalihan',
              value: '$formattedDate | ${shiftStocks.shiftingTime}'
            ),
            const SizedBox(height: 4,),
            TableDataWidget(
              widthTitleBox: 150,
              title: 'Produk asal',
              value: shiftStocks.sourceProductName
            ),
            const SizedBox(height: 4,),
            TableDataWidget(
              widthTitleBox: 150,
              title: 'Jumlah pengalihan',
              value: '${shiftStocks.quantity.toString()} buah'
            ),
            const SizedBox(height: 4,),
            TableDataWidget(
              widthTitleBox: 150,
              title: 'Dialihkan ke',
              value: shiftStocks.shiftStockDestination.destProductName
            ),
            const SizedBox(height: 8),
            RichText(text:
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Dengan pengalihan ini, stok '
                        '${shiftStocks.shiftStockDestination.destProductName} '
                        'bertambah ',
                    style: secondaryTextStyle,
                  ),
                  TextSpan(
                    text: '${shiftStocks.shiftStockDestination.qtyDest.toString()} buah',
                    style: priceTextStyle,
                  )
                ]
              ),
            ),
            const SizedBox(height: 8),
            shiftStocks.isDeletedSourceProduct != null || shiftStocks.shiftStockDestination.isDeletedDestProduct != null
            ? const SizedBox()
            : OutlinedButton(
                onPressed: () {
                  areYouSureDialog();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: alertColor,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  padding: const EdgeInsets.all(8),
                ),
                child: Text(
                  'Batalkan pengalihan',
                  style: alertTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 13,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
