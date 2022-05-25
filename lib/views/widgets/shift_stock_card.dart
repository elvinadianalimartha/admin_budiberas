import 'package:budiberas_admin_9701/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/shift_stock_model.dart';

class ShiftStockCard extends StatelessWidget {
  final ShiftStockModel shiftStocks;

  const ShiftStockCard({
    Key? key,
    required this.shiftStocks
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(shiftStocks.shiftingDate);

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
            Row(
              children: [
                Text(
                  'Waktu pengalihan',
                  style: primaryTextStyle,
                ),
                const SizedBox(width: 16,),
                const Text(':'),
                const SizedBox(width: 8,),
                Flexible(
                  child: Text(
                    '$formattedDate | ${shiftStocks.shiftingTime} WIB',
                    style: primaryTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            const SizedBox(height: 4,),
            Row(
              children: [
                Text(
                  'Produk asal',
                  style: primaryTextStyle,
                ),
                const SizedBox(width: 63,),
                const Text(':'),
                const SizedBox(width: 8,),
                Flexible(
                  child: Text(
                    shiftStocks.sourceProductName,
                    style: primaryTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            const SizedBox(height: 4,),
            Row(
              children: [
                Text(
                  'Jumlah pengalihan',
                  style: primaryTextStyle,
                ),
                const SizedBox(width: 8,),
                const Text(':'),
                const SizedBox(width: 8,),
                Flexible(
                  child: Text(
                    '${shiftStocks.quantity.toString()} (x ${shiftStocks.sourceProductSize})',
                    style: primaryTextStyle,
                  ),
                )
              ],
            ),
            const SizedBox(height: 4,),
            Row(
              children: [
                Text(
                  'Dialihkan ke',
                  style: primaryTextStyle,
                ),
                const SizedBox(width: 61,),
                const Text(':'),
                const SizedBox(width: 8,),
                Flexible(
                  child: Text(
                    shiftStocks.shiftStockDestination.destProductName,
                    style: primaryTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
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
            OutlinedButton(
              onPressed: () {

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
