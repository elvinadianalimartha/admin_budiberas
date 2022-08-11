import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/product_model.dart';
import '../../theme.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;

class ChatBubble extends StatelessWidget {

  final String text;
  final bool isSender; //if true, berarti pengirim. if false penerima
  final ProductModel? product;
  final DateTime createdAt;

  ChatBubble({
    required this.isSender,
    this.text = '',
    this.product,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    String formattedDate = DateFormat('dd-MM-yyyy HH:mm', 'id').format(createdAt);
    
    Widget productPreview(){
      return Container(
        width: 240,
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSender ? fourthColor.withOpacity(0.8) : formColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          )
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: product!.galleries.isNotEmpty
                     ? Image.network(
                        constants.urlPhoto + product!.galleries[0].url.toString(),
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return Icon(Icons.image_not_supported_rounded, color: secondaryTextColor, size: 60,);
                        },
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ): Icon(Icons.image, color: secondaryTextColor, size: 60,),
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product!.name,
                        style: primaryTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Rp ${formatter.format(product!.price)}',
                        style: priceTextStyle.copyWith(
                          fontWeight: semiBold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    //bagian chat bubble
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          product is UninitializedProductModel ? const SizedBox() : productPreview(),
          Row(
            mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6, //spy ukuran bubblenya max cm 60% dr ukuran layar
                  ),
                  padding: EdgeInsets.only(
                    right: 16,
                    left: 16,
                    top: 12,
                    bottom: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSender ? fourthColor.withOpacity(0.8) : Color(0xffEAEAF1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSender ? 12 : 0),
                      topRight: Radius.circular(isSender ? 0 : 12),
                      bottomLeft: const Radius.circular(12),
                      bottomRight: const Radius.circular(12),
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: primaryTextStyle,
                      ),
                      SizedBox(height: 6,),
                      Text(
                        formattedDate,
                        style: isSender ? priceTextStyle.copyWith(fontSize: 11) : secondaryTextStyle.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
