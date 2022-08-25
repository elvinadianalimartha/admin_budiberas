import 'package:budiberas_admin_9701/providers/shipping_rate_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/add_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/line_text_field.dart';
import 'package:budiberas_admin_9701/views/widgets/special_rate_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/reusable/cancel_button.dart';
import '../widgets/reusable/done_button.dart';

class ShippingRatePage extends StatefulWidget {
  const ShippingRatePage({Key? key}) : super(key: key);

  @override
  State<ShippingRatePage> createState() => _ShippingRatePageState();
}

class _ShippingRatePageState extends State<ShippingRatePage> {
  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<ShippingRateProvider>(context, listen: false).getShippingRates();
  }

  @override
  Widget build(BuildContext context) {
    ShippingRateProvider shippingRateProv = Provider.of<ShippingRateProvider>(context);

    TextEditingController updateStandardPriceCtrl = TextEditingController(text: '');
    TextEditingController newShipPriceCtrl = TextEditingController(text: '');
    TextEditingController minOrderPriceCtrl = TextEditingController(text: '');
    TextEditingController maxDistanceCtrl = TextEditingController(text: '');

    final _formKeyEditStandard = GlobalKey<FormState>();
    final _formKeyAddSpecial = GlobalKey<FormState>();

    var formatter = NumberFormat.decimalPattern('id');

    void disposeSpecialPrice() {
      newShipPriceCtrl.clear();
      minOrderPriceCtrl.clear();
      maxDistanceCtrl.clear();
    }

    handleAddSpecialPrice({
      required double shippingPrice,
      required double minOrderPrice,
      required double maxDistance
    }) async{
      if(await shippingRateProv.createShippingRate(
          shippingPrice: shippingPrice,
          minOrderPrice: minOrderPrice,
          maxDistance: maxDistance)
      ) {
        Navigator.pop(context);
        disposeSpecialPrice();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya khusus berhasil ditambahkan'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        shippingRateProv.getShippingRates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya khusus gagal ditambahkan'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> showModalAddSpecial() {
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
                  key: _formKeyAddSpecial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tambah Biaya Khusus',
                          style: primaryTextStyle.copyWith(fontWeight: semiBold),
                        ),
                        const SizedBox(height: 2,),
                        Text(
                          'Tentukan syarat untuk memperoleh biaya khusus',
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
                              controller: maxDistanceCtrl,
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
                              controller: minOrderPriceCtrl,
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
                              'Biaya khusus (set jadi 0 jika gratis) : ',
                              style: primaryTextStyle,
                            ),
                            LineTextField(
                              inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                              textInputType: TextInputType.number,
                              actionKeyboard: TextInputAction.done,
                              controller: newShipPriceCtrl,
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
                                    if(_formKeyAddSpecial.currentState!.validate()) {
                                      handleAddSpecialPrice(
                                          shippingPrice: double.parse(newShipPriceCtrl.text),
                                          minOrderPrice: double.parse(minOrderPriceCtrl.text),
                                          maxDistance: double.parse(maxDistanceCtrl.text)
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

    //NOTE: Edit biaya standar
    handleEditStandardPrice(int shippingPrice) async{
      if(await shippingRateProv.updateRate(
          id: shippingRateProv.standardShippingRates.id,
          shippingPrice: shippingPrice)
      ) {
        Navigator.pop(context);
        updateStandardPriceCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya standar berhasil diperbarui'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Biaya standar gagal diperbarui'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    //NOTE: modal bottom sheet edit biaya standar
    Future<void> showModalEditStandard() {
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
                        'Ubah Biaya Standar per Kilometer',
                        style: primaryTextStyle.copyWith(fontWeight: semiBold),
                      ),
                      const Divider(thickness: 1,),
                      Text(
                        'Biaya sebelumnya : Rp ${formatter.format(shippingRateProv.standardShippingRates.shippingPrice)}/km',
                        style: primaryTextStyle,
                      ),
                      const SizedBox(height: 16,),
                      Form(
                        key: _formKeyEditStandard,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ubah biaya standar menjadi : ',
                              style: primaryTextStyle,
                            ),
                            LineTextField(
                              actionKeyboard: TextInputAction.done,
                              controller: updateStandardPriceCtrl,
                              hintText: 'Masukkan biaya standar yang baru',
                              prefixIcon: Text('Rp  ', style: greyTextStyle,),
                              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                              validator: (value) {
                                if(value!.isEmpty) {
                                  return 'Data harus diisi sebelum disimpan';
                                }
                                return null;
                              }
                            )
                          ],
                        ),
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
                                  updateStandardPriceCtrl.clear();
                                },
                              )
                          ),
                          SizedBox(
                              width: 150,
                              child: DoneButton(
                                onClick: () {
                                  if(_formKeyEditStandard.currentState!.validate()) {
                                    handleEditStandardPrice(int.parse(updateStandardPriceCtrl.text));
                                  }
                                },
                              )
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                    ]
                ),
              )
      );
    }

    Widget standardPrice() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Biaya Standar : ',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 16)
                ),
                TextSpan(
                    text: 'Rp ${formatter.format(shippingRateProv.standardShippingRates.shippingPrice)}/km',
                    style: primaryTextStyle.copyWith(fontSize: 16)
                ),
              ]
            )
          ),
          EditButton(
            text: 'Ubah',
            onClick: (){
              showModalEditStandard();
            },
          ),
        ],
      );
    }

    Widget specialPrice() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Biaya Khusus',
                style: primaryTextStyle.copyWith(fontWeight: semiBold),
              ),
              Flexible(
                child: SizedBox(
                  width: 200,
                  child: AddButton(
                    onClick: () {
                      showModalAddSpecial();
                    },
                    text: 'Tambah Data',
                    icon: Icons.add_circle_outlined,
                  )
                )
              )
            ],
          ),
          const SizedBox(height: 16,),
          shippingRateProv.specialShippingRates.isEmpty
            ? Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                  child: Text(
                    'Belum ada data biaya khusus',
                    style: greyTextStyle,
                  ),
                ),
            )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: shippingRateProv.specialShippingRates.length,
                itemBuilder: (context, index) {
                  return SpecialRateCard(specialShippingRate: shippingRateProv.specialShippingRates[index]);
                }
              )
        ],
      );
    }

    Widget loadingWidget() {
      return const Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: Center(
            child: CircularProgressIndicator()
        ),
      );
    }

    Widget content() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              standardPrice(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(thickness: 2,),
              ),
              specialPrice(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Atur Biaya Pengantaran'),
      body: shippingRateProv.loadingGetRates
          ? loadingWidget()
          : content(),
    );
  }
}
