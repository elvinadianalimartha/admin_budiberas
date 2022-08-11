import 'package:budiberas_admin_9701/models/shipping_rates_model.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/cancel_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/delete_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/line_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/shipping_rate_provider.dart';
import '../../theme.dart';

class SpecialRateCard extends StatelessWidget {
  final ShippingRatesModel specialShippingRate;

  const SpecialRateCard({
    Key? key,
    required this.specialShippingRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    final _formKeyEditSpecial = GlobalKey<FormState>();

    num formattedMaxDistance;
    var decimalNumber = specialShippingRate.maxDistance! % 1; //get decimal value (angka di belakang koma)
    if(decimalNumber == 0) {
      formattedMaxDistance = specialShippingRate.maxDistance!.toInt();
    } else {
      formattedMaxDistance = specialShippingRate.maxDistance!;
    }

    TextEditingController updateSpecialShipPriceCtrl = TextEditingController(text: specialShippingRate.shippingPrice.toString());
    TextEditingController updateMinOrderPriceCtrl = TextEditingController(text: specialShippingRate.minOrderPrice.toString());
    TextEditingController updateMaxDistanceCtrl = TextEditingController(text: formattedMaxDistance.toString());

    void disposeSpecialPrice() {
      updateSpecialShipPriceCtrl.clear();
      updateMinOrderPriceCtrl.clear();
      updateMaxDistanceCtrl.clear();
    }

    handleEditSpecialData({
      required int newShippingPrice,
      required double newMaxDistance,
      required int newMinOrderPrice,
    }) async{
      if(await context.read<ShippingRateProvider>().updateRate(
          id: specialShippingRate.id,
          shippingPrice: newShippingPrice,
          maxDistance: newMaxDistance,
          minOrderPrice: newMinOrderPrice
      )) {
        Navigator.pop(context);
        disposeSpecialPrice();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya khusus berhasil diperbarui'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya khusus gagal diperbarui'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> showModalEditSpecial() {
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) =>
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKeyEditSpecial,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ubah Biaya Khusus',
                            style: primaryTextStyle.copyWith(fontWeight: semiBold),
                          ),
                          const SizedBox(height: 2,),
                          Text(
                            'Ubah syarat untuk memperoleh biaya khusus',
                            style: priceTextStyle.copyWith(fontSize: 13),
                          ),
                          const Divider(thickness: 1,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jarak maksimal : ',
                                style: primaryTextStyle,
                              ),
                              LineTextField(
                                textInputType: TextInputType.number,
                                controller: updateMaxDistanceCtrl,
                                hintText: 'Masukkan ketentuan jarak maksimal',
                                suffixIcon: Text('km', style: greyTextStyle,),
                                suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return 'Jarak maksimal harus diisi';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 16,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pembelian minimal : ',
                                style: primaryTextStyle,
                              ),
                              LineTextField(
                                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                textInputType: TextInputType.number,
                                controller: updateMinOrderPriceCtrl,
                                hintText: 'Masukkan ketentuan pembelian minimal',
                                prefixIcon: Text('Rp  ', style: greyTextStyle,),
                                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return 'Pembelian minimal harus diisi';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 16,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Biaya khusus : ',
                                style: primaryTextStyle,
                              ),
                              Text(
                                'Set jadi 0 jika gratis',
                                style: greyTextStyle,
                              ),
                              LineTextField(
                                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                                textInputType: TextInputType.number,
                                actionKeyboard: TextInputAction.done,
                                controller: updateSpecialShipPriceCtrl,
                                hintText: 'Masukkan biaya yang dikenakan',
                                prefixIcon: Text('Rp  ', style: greyTextStyle,),
                                prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                validator: (value) {
                                  if(value!.isEmpty) {
                                    return 'Biaya harus diisi';
                                  }
                                  return null;
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  width: 150,
                                  child: CancelButton(
                                    onClick: () {
                                      Navigator.pop(context);
                                      disposeSpecialPrice();
                                    },
                                  )
                              ),
                              SizedBox(
                                  width: 150,
                                  child: DoneButton(
                                    onClick: () {
                                      if(_formKeyEditSpecial.currentState!.validate()) {
                                        handleEditSpecialData(
                                            newShippingPrice: int.parse(updateSpecialShipPriceCtrl.text),
                                            newMinOrderPrice: int.parse(updateMinOrderPriceCtrl.text),
                                            newMaxDistance: double.parse(updateMaxDistanceCtrl.text)
                                        );
                                      }
                                    },
                                  )
                              ),
                            ],
                          ),
                          const SizedBox(height: 20,),
                        ]
                    ),
                  ),
                ),
              )
      );
    }

    handleDeleteSpecialData() async{
      if(await context.read<ShippingRateProvider>().deleteRate(id: specialShippingRate.id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya khusus berhasil dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya khusus gagal dihapus'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> areYouSureToDeleteDialog() async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
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
                  'Apakah Anda yakin akan menghapus ketentuan ini?',
                  style: primaryTextStyle, textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jarak max: $formattedMaxDistance km',
                      style: greyTextStyle, textAlign: TextAlign.left,
                    ),
                    Text(
                      'Min. pembelian: Rp ${formatter.format(specialShippingRate.minOrderPrice)}',
                      style: greyTextStyle, textAlign: TextAlign.left,
                    ),
                    Text(
                      'Biaya yang dikenakan: Rp ${formatter.format(specialShippingRate.shippingPrice)}',
                      style: greyTextStyle, textAlign: TextAlign.left,
                    ),
                  ],
                ),
                SizedBox(height: defaultMargin,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CancelButton(
                          onClick: () {
                            Navigator.pop(context);
                          }
                      ),
                      const SizedBox(width: 50,),
                      DoneButton(
                        text: 'Hapus',
                        onClick: handleDeleteSpecialData
                      ),
                    ]
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget tableSpecialRates({
      required String title,
      required String value,
    }) {
      return Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: primaryTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(':'),
          ),
          Flexible(
            child: Text(
              value,
              style: primaryTextStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
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
              right: 16,
              left: 16,
            ),
            child: Column(
              children: [
                tableSpecialRates(
                    title: 'Jarak max',
                    value: '$formattedMaxDistance km'
                ),
                const SizedBox(height: 10),
                tableSpecialRates(
                  title: 'Pembelian minimal',
                  value: 'Rp ${formatter.format(specialShippingRate.minOrderPrice)}',
                ),
                const SizedBox(height: 10),
                tableSpecialRates(
                  title: 'Biaya',
                  value: specialShippingRate.shippingPrice == 0
                      ? 'Gratis'
                      : 'Rp ${formatter.format(specialShippingRate.shippingPrice)}',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                EditButton(
                    text: 'Ubah',
                    iconSize: 15,
                    onClick: () {
                      showModalEditSpecial();
                    }
                ),
                const SizedBox(width: 20,),
                DeleteButton(
                    onClick: () {
                      areYouSureToDeleteDialog();
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
