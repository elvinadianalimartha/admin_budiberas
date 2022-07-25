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

import '../../models/incoming_stock_model.dart';
import '../../providers/incoming_stock_provider.dart';
import '../../theme.dart';

class IncomingStocksCard extends StatelessWidget {
  final IncomingStockModel incomingStocks;
  final IncomingStockProvider? incomingProvider;
  IncomingStocksCard({
    required this.incomingStocks,
    this.incomingProvider,
    Key? key,
}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController editQtyController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(incomingStocks.incomingDate);

    handleEditData(int updatedQty) async{
      if(await incomingProvider!.updateIncomingStock(id: incomingStocks.id, quantity: updatedQty)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Jumlah masuk berhasil diperbarui'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        incomingProvider!.getIncomingStocks(statusParam: incomingStocks.incomingStatus);
      } else {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Jumlah gagal diperbarui'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
      );
      }
    }

    Future<void> showModalUpdateStock() {
      return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                incomingStocks.incomingStatus == 'Retur dari pembeli'
                    ? 'Ubah Jumlah Retur'
                    : 'Ubah Jumlah Stok yang Ditambahkan',
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                'Produk\t\t\t\t: ${incomingStocks.product}',
                style: secondaryTextStyle.copyWith(
                  fontWeight: medium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4,),
              Text(
                'Waktu masuk\t: $formattedDate | ${incomingStocks.incomingTime}',
                style: secondaryTextStyle.copyWith(
                  fontWeight: medium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah masuk :',
                    style: greyTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: Text(
                      '${incomingStocks.quantity}',
                      style: primaryTextStyle,
                    )
                  )
                ],
              ),
              const SizedBox(height: 8,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Ubah jumlah masuk menjadi :',
                          style: greyTextStyle.copyWith(
                            fontWeight: medium,
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Flexible(
                          child: LineTextField(
                            hintText: '',
                            actionKeyboard: TextInputAction.done,
                            textInputType: TextInputType.number,
                            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            controller: editQtyController,
                            validator: (value){
                              if (value!.isEmpty) {
                                return 'Jumlah harus diisi!';
                              } else if(int.parse(value) <= 0) {
                                return 'Jumlah harus lebih dari 0!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 150,
                          child: CancelButton(
                              onClick: () {
                                Navigator.pop(context);
                                editQtyController.clear();
                              }
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: DoneButton(
                              text: 'Simpan',
                              onClick: () {
                                if(_formKey.currentState!.validate()) {
                                  handleEditData(int.parse(editQtyController.text));
                                }
                              }
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36,),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    handleDeleteData() async {
      if(await incomingProvider!.deleteIncomingStock(id: incomingStocks.id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data berhasil dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        incomingProvider!.getIncomingStocks(statusParam: incomingStocks.incomingStatus);
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
              text: 'Apakah Anda yakin akan menghapus stok masuk '
                  'sebanyak ${incomingStocks.quantity} '
                  'dari produk ${incomingStocks.product}?',
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
                      handleDeleteData();
                    }
                ),
              ],
            )
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
                        incomingStocks.product,
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
                    Flexible(
                      child: Text(
                        '$formattedDate | ${incomingStocks.incomingTime}',
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
                      'Jumlah Masuk',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 28,),
                    const Text(':'),
                    const SizedBox(width: 8,),
                    Text(
                      '${incomingStocks.quantity} buah',
                      style: primaryTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          incomingStocks.isDeletedProduct == null
            ? ListTile(
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
                        showModalUpdateStock();
                      }
                  ),
                  const SizedBox(width: 20,),
                  DeleteButton(
                    onClick: () {
                      areYouSureDialog();
                    }
                  ),
                ],
              ),
            )
          : const SizedBox(height: 6,),
        ],
      ),
    );
  }
}

