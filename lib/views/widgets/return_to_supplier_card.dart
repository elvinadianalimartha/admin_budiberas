import 'package:budiberas_admin_9701/models/out_stock_model.dart';
import 'package:budiberas_admin_9701/services/out_stock_service.dart';
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

import '../../providers/out_stock_provider.dart';
import '../../theme.dart';

class ReturnToSupplierCard extends StatelessWidget {
  final OutStockModel outStocks;
  final OutStockProvider? outStockProvider;

  ReturnToSupplierCard({
    required this.outStocks,
    this.outStockProvider,
    Key? key,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  TextEditingController editQtyController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(outStocks.outDate);

    handleEditData(int updatedQty) async{
      if(await outStockProvider!.updateOutStock(id: outStocks.id, quantity: updatedQty)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Jumlah retur berhasil diperbarui'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        outStockProvider!.getOutStocks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Jumlah gagal diperbarui'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> showModalUpdateStock() async {
      int maxOutQty = await OutStockService().getMaxOutQty(outStocks.id);

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
                'Ubah Jumlah Retur ke Supplier',
                style: primaryTextStyle.copyWith(
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(height: 8,),
              Text(
                'Produk\t\t\t\t: ${outStocks.productName}',
                style: greyTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 4,),
              Text(
                'Waktu keluar\t: $formattedDate | ${outStocks.outTime}',
                style: greyTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
              const SizedBox(height: 8,),
              const Divider(thickness: 1,),
              const SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Jumlah keluar :',
                    style: greyTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Flexible(
                      child: Text(
                        '${outStocks.quantity}',
                        style: greyTextStyle,
                      )
                  )
                ],
              ),
              const SizedBox(height: 12,),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubah jumlah menjadi :',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    Text(
                        '(Maksimal $maxOutQty)',
                        style: priceTextStyle
                    ),
                    LineTextField(
                      hintText: '',
                      actionKeyboard: TextInputAction.done,
                      textInputType: TextInputType.number,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      controller: editQtyController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Jumlah harus diisi!';
                        } else if(int.parse(value) <= 0) {
                          return 'Jumlah harus lebih dari 0!';
                        } else if(int.parse(value) > maxOutQty) {
                          return 'Jumlah retur tidak bisa melebihi $maxOutQty';
                        }
                        return null;
                      },
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
      if(await outStockProvider!.deleteOutStock(id: outStocks.id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data berhasil dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        outStockProvider!.getOutStocks();
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
              text: 'Apakah Anda yakin akan menghapus stok keluar '
                  'sebanyak ${outStocks.quantity} '
                  'dari produk ${outStocks.productName}?',
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
                        outStocks.productName,
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
                      'Waktu Keluar',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 36,),
                    const Text(':'),
                    const SizedBox(width: 8,),
                    Text(
                      '$formattedDate | ${outStocks.outTime} WIB',
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
                      'Jumlah Keluar',
                      style: primaryTextStyle.copyWith(
                        fontWeight: medium,
                      ),
                    ),
                    const SizedBox(width: 28,),
                    const Text(':'),
                    const SizedBox(width: 8,),
                    Text(
                      '${outStocks.quantity} buah',
                      style: primaryTextStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          outStocks.isDeletedProduct == null
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
