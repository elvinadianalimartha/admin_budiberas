import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/views/form/edit_data_product.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/alert_dialog.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/cancel_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/line_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:provider/provider.dart';

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
    String updatedStatus = '';

    ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    handleUpdateStatus({
      required int idToUpdate,
      required String stockStatus,
    }) async {
      if(await productProvider.updateActivationProduct(id: idToUpdate, stockStatus: stockStatus)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Status produk berhasil diperbarui'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        productProvider.getProducts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Status produk gagal diperbarui'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    handleDeleteData(int id) async {
      if(await productProvider.deleteProduct(id: id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data berhasil dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        productProvider.getProducts();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data gagal dihapus'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> areYouSureDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
            child: AlertDialogWidget(
              text: 'Apakah Anda yakin akan menghapus produk ${product.name}?',
              childrenList: [
                CancelButton(
                    onClick: () {
                      Navigator.pop(context);
                    }
                ),
                const SizedBox(width: 50,),
                DoneButton(
                    text: 'Hapus',
                    onClick: () {
                      handleDeleteData(product.id);
                    }
                ),
              ],
            )
        ),
      );
    }

    Future<void> modalUpdatePrice() async {
      return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Ubah Harga ${product.name}',
                  style: primaryTextStyle.copyWith(
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 20,),
                Text(
                  'Harga sebelumnya\t\t\t\t: \t\tRp ${formatter.format(product.price.toInt())}',
                  style: primaryTextStyle,
                ),
                const SizedBox(height: 10,),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ubah harga menjadi\t\t: ',
                          style: primaryTextStyle,
                        ),
                        const SizedBox(width: 5,),
                        Flexible(
                          child: LineTextField(
                              hintText: '',
                              prefixIcon: Text(
                                  '\t\t\t\tRp\t\t',
                                  style: secondaryTextStyle,
                              ),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              //controller: priceController,
                              textInputType: TextInputType.number,
                              inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harga produk harus diisi';
                                }
                                return null;
                              },
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                            child: CancelButton(
                              onClick: () {
                                Navigator.pop(context);
                              },
                            )
                        ),
                        SizedBox(
                            width: 150,
                            child: DoneButton(
                              onClick: () {

                              },
                            )
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20,),
              ],
            ),
          );
        }
      );
    }

    Future<void> kebabMenu() async {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      int? selected = await showMenu(
        elevation: 5,
        context: context,
        position: RelativeRect.fromLTRB(
          offset.dx + 1,
          offset.dy,
          offset.dx,
          offset.dy,
        ),
        items: [
          product.stock != 0 ?
          PopupMenuItem(
            child:
            product.stockStatus.toLowerCase() == 'aktif'
                ? Text('Nonaktifkan Produk', style: primaryTextStyle,)
                : Text('Aktifkan Produk', style: primaryTextStyle,),
            value: 1,
          )
              : const PopupMenuItem(height: 0, child: null, value: null, enabled: false,),
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
      switch(selected) {
        case 1:
          if(product.stockStatus.toLowerCase() == 'aktif') {
            updatedStatus = 'Tidak aktif';
          } else {
            updatedStatus = 'Aktif';
          }
          handleUpdateStatus(
            idToUpdate: product.id,
            stockStatus: updatedStatus
          );
          break;
        case 2:
          modalUpdatePrice();
          break;
        case 3:
          areYouSureDialog();
          break;
      }
    }

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
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FormEditDataProduct(product: product))
                      );
                    }
                ),
              ],
            ),
            trailing: IconButton(
               icon: Icon(Icons.more_vert, color: secondaryTextColor),
                onPressed: () {
                  kebabMenu();
                },
              )
            ),
        ],
      ),
    );
  }
}

