import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;

import '../../models/product_model.dart';
import '../../theme.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  ProductCard({
    required this.product,
    Key? key,
}) : super(key: key);

  var formatter = NumberFormat.decimalPattern('id');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
        left: 20,
        right: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: secondaryTextColor.withOpacity(0.8), width: 0.5),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 10,
              right: 16,
              left: 16,
            ),
            child: Row(
              children: [
                //Photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product.galleries.isNotEmpty ?
                  Image.network(
                    constants.urlPhoto + product.galleries[0].url.toString(),
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Icon(Icons.image, color: secondaryTextColor, size: 60,);
                    },
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ): Icon(Icons.image, color: secondaryTextColor, size: 60,),
                ),

                const SizedBox(width: 16,),

                //Product data
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              product.name,
                              style: primaryTextStyle.copyWith(
                                fontWeight: semiBold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        'Rp ${formatter.format(product.price)}',
                        style: priceTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      ),
                      const SizedBox(height: 4,),
                      Row(
                        children: [
                          Text(
                            'Stok: ${product.stock}',
                            style: secondaryTextStyle.copyWith(
                              fontWeight: medium,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 12,),
                          product.stockStatus.toLowerCase() == 'tidak aktif' ?
                            Container(
                              color: const Color(0xffEBEBEB),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              child: Text(
                                'Tidak aktif',
                                style: secondaryTextStyle.copyWith(
                                  fontWeight: medium,
                                  fontSize: 12,
                                ),
                              )
                            ) :
                            const SizedBox(),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(
              right: 16,
              left: 16,
              bottom: 16,
            ),
            title: Row(
              children: [
                EditButton(
                  text: 'Ubah Foto',
                  icon: Icons.camera_alt,
                  iconSize: 15,
                  onClick: () {
                  }
                ),
                const SizedBox(width: 20,),
                EditButton(
                    text: 'Ubah Data',
                    onClick: () {
                    }
                ),
              ],
            ),
            trailing: IconButton(
               icon: Icon(Icons.more_vert, color: secondaryTextColor),
                onPressed: () {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  Offset offset = renderBox.localToGlobal(Offset.zero);
                  showMenu(
                    elevation: 5,
                    context: context,
                    position: RelativeRect.fromLTRB(
                      offset.dx + 1,
                      offset.dy,
                      offset.dx,
                      offset.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        child: Text('Nonaktifkan Produk', style: primaryTextStyle,),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text('Ubah Harga', style: primaryTextStyle,),
                        value: 2,
                      ),
                      PopupMenuItem(
                        child: Text('Hapus', style: alertTextStyle),
                        value: 3,
                      )
                    ],
                  );
                },
              )
            ),
        ],
      ),
    );
  }
}

