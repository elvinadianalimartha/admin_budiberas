import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/views/form/edit_data_product.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/alert_dialog.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/cancel_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/delete_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/line_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../../models/incoming_stock_model.dart';
import '../../models/product_model.dart';
import '../../providers/incoming_stock_provider.dart';
import '../../theme.dart';

class IncomingStocksCard extends StatefulWidget {
  final IncomingStockModel incomingStocks;
  //kayaknya bisa transfer incomingstockprovider di sini
  IncomingStocksCard({
    required this.incomingStocks,
    Key? key,
}) : super(key: key);

  @override
  State<IncomingStocksCard> createState() => _IncomingStocksCardState();
}

class _IncomingStocksCardState extends State<IncomingStocksCard> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String updatedStatus = '';

  TextEditingController newPriceController = TextEditingController(text: '');

  @override
  void dispose() {
    updatedStatus = '';
    newPriceController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IncomingStockProvider incomingStockProvider = Provider.of<IncomingStockProvider>(context, listen: false);
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(widget.incomingStocks.incomingDate);

    // handleDeleteData(int id) async {
    //   if(await incomingStockProvider.deleteProduct(id: id)) {
    //     Navigator.pop(context);
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: const Text('Data berhasil dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
    //     );
    //     incomingStockProvider.getProducts();
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: const Text('Data gagal dihapus'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
    //     );
    //   }
    // }

    // Future<void> areYouSureDialog() async {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) => SizedBox(
    //         child: AlertDialogWidget(
    //           text: 'Apakah Anda yakin akan menghapus stok masuk ${widget.product.name}?',
    //           childrenList: [
    //             CancelButton(
    //                 onClick: () {
    //                   Navigator.pop(context);
    //                 }
    //             ),
    //             const SizedBox(width: 50,),
    //             DoneButton(
    //                 text: 'Hapus',
    //                 onClick: () {
    //                   handleDeleteData(widget.product.id);
    //                 }
    //             ),
    //           ],
    //         )
    //     ),
    //   );
    // }

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
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Produk',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 80,),
                    const Text(':'),
                    const SizedBox(width: 8,),
                    Flexible(
                      child: Text(
                        widget.incomingStocks.product,
                        style: primaryTextStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Waktu Masuk',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 36,),
                    const Text(':'),
                    const SizedBox(width: 8,),
                    Text(
                      '${formattedDate} | ${widget.incomingStocks.incomingTime} WIB',
                      style: primaryTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Jumlah Masuk',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 28,),
                    const Text(':'),
                    const SizedBox(width: 8,),
                    Text(
                      '${widget.incomingStocks.quantity}',
                      style: primaryTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
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
                    text: 'Ubah',
                    iconSize: 15,
                    onClick: () {
                    }
                ),
                const SizedBox(width: 20,),
                DeleteButton(
                    onClick: () {

                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

