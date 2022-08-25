import 'package:budiberas_admin_9701/providers/shifting_stock_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../services/suggestion_product_service.dart';
import '../../theme.dart';
import '../widgets/reusable/text_field.dart';

class FormShiftingStock extends StatefulWidget {
  const FormShiftingStock({Key? key}) : super(key: key);

  @override
  _FormShiftingStockState createState() => _FormShiftingStockState();
}

class _FormShiftingStockState extends State<FormShiftingStock> {
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  TextEditingController sourceProductController = TextEditingController(text: '');
  TextEditingController shiftQtyController = TextEditingController(text: '');
  TextEditingController destinationProductController = TextEditingController(text: '');
  int? sourceProdId; //untuk mengetahui siapa saja destination productnya
  int? destProdId;
  double? sourceSize;
  double? destSize;

  late ShiftingStockProvider shiftingStockProvider;

  int? destRoundQty;

  @override
  void initState() {
    shiftingStockProvider = Provider.of<ShiftingStockProvider>(context, listen: false);

    //saat pertama kali buka page form shifting stock, app akan load source product suggestions dari API
    Provider.of<ShiftingStockProvider>(context, listen: false).getSourceProductSuggestions('');
    super.initState();
  }

  @override
  void dispose() {
    sourceProductController.clear();
    shiftQtyController.clear();
    destinationProductController.clear();
    shiftingStockProvider.disposeValue();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleAddData() async{
      if(await shiftingStockProvider.shiftingStock(
        sourceProductId: sourceProdId!,
        destProductId: destProdId!,
        quantity: int.parse(shiftQtyController.text),
        destQty: shiftingStockProvider.clickChangeDestQty ? shiftingStockProvider.destQtyToChange : destRoundQty!)
      ) {
        //Back to manage product page with newly created product
        shiftingStockProvider.getShiftStocks();
        Navigator.popUntil(context, ModalRoute.withName('/manage-shifting-stock'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Stok berhasil dialihkan'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Stok gagal dialihkan'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          )
        );
      }
    }

    Widget sourceProduct(){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama produk asal',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKeys[0],
            child: Consumer<ShiftingStockProvider>(
              builder: (context, data, child){
                return TypeAheadFormField<ProductModel> (
                    suggestionsCallback: (pattern) async{
                      return await SuggestionProductService().getCanBeRetailedProduct(pattern);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Produk asal harus diisi';
                      } else if (data.validateSourceProduct(value) == false) {
                        return 'Mohon pilih nama produk yang ada di daftar';
                      }
                      return null;
                    },
                    hideSuggestionsOnKeyboardHide: false,
                    debounceDuration: const Duration(milliseconds: 500),
                    textFieldConfiguration: TextFieldConfiguration(
                        style: primaryTextStyle.copyWith(fontSize: 14),
                        controller: sourceProductController,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          contentPadding: const EdgeInsets.all(16),
                          fillColor: formColor,
                          hintText: 'Pilih/cari produk asal',
                          hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                        ),
                        onEditingComplete: (){
                          formKeys[0].currentState!.validate()
                            ? (){}
                            : [data.sourceIsNotSet(),
                              sourceProdId = null,
                              shiftQtyController.clear(),
                              destinationProductController.clear(),
                              FocusScope.of(context).unfocus(),];
                        },
                    ),
                    onSuggestionSelected: (ProductModel suggestion) {
                      sourceProductController.text = suggestion.name;

                      //kalau source prod id sudah ada isinya (yg berarti source sudah prnah diisi sebelumnya)
                      //maka destination sebelumnya harus diclear terlebih dulu
                      if(sourceProdId != null) {
                        shiftQtyController.clear();
                        destinationProductController.clear();
                      }

                      sourceProdId = suggestion.id;
                      sourceSize = suggestion.size;
                      data.getDestProductSuggestions('',sourceProdId!);
                      data.setMaxShiftQty(suggestion.stock); //NOTE: di sini product source akan diset true dan set max qty

                      //NOTE: saat pilih source baru, clicked change destnya di-reset jd false lg
                      data.clickToChangeDestQty(false);
                    },
                    itemBuilder: (context, ProductModel suggestion) {
                      return ListTile(
                        title: Text(suggestion.name, style: primaryTextStyle,),
                      );
                    },
                    errorBuilder: (context, error) => SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Terjadi kesalahan, mohon ulangi pencarian',
                          style: alertTextStyle,
                        ),
                      ),
                    ),
                    noItemsFoundBuilder: (context) => SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Produk tidak ditemukan',
                          style: greyTextStyle,
                        ),
                      ),
                    )
                );
              }
            ),
          ),
        ],
      );
    }

    Widget shiftQty() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jumlah pengalihan',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Consumer<ShiftingStockProvider>(
            builder: (context, data, child) {
              return data.sourceProductValue == true
                ? Text(
                    'Maksimal ${data.maxQty} buah',
                    style: priceTextStyle.copyWith(
                      fontSize: 12,
                    ),
                  )
                : Text(
                    'Mohon isi produk asal dengan benar terlebih dulu',
                    style: secondaryTextStyle.copyWith(
                      fontSize: 12
                    ),
                  );
            }
          ),
          const SizedBox(height: 8,),
          Form(
            key: formKeys[1],
            child: Consumer<ShiftingStockProvider>(
              builder: (context, data, child){
                return TextFormFieldWidget(
                  hintText: 'Masukkan jumlah yang mau dialihkan',
                  controller: shiftQtyController,
                  textInputType: TextInputType.number,
                  actionKeyboard: TextInputAction.done,
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  readOnly: data.sourceProductValue == true
                      ? false
                      : true, //kalau value source product false, maka readOnlynya true
                  validator: (value) {
                    if(data.sourceProductValue) {
                      if (value!.isEmpty) {
                        return 'Jumlah pengalihan harus diisi';
                      } else if(int.parse(value) > data.maxQty!) {
                        return 'Jumlah pengalihan maksimal ${data.maxQty} buah!';
                      } else if(int.parse(value) < 1) {
                        return 'Jumlah pengalihan harus lebih dari 0 buah';
                      }
                      return null;
                    }
                    return null;
                  },
                  onChanged: (shiftQtyController) {
                    if(formKeys[1].currentState!.validate()) {
                      data.setQtyValue(true);
                    } else {
                      data.setQtyValue(false);
                    }
                    //NOTE: saat ubah nilai jml yg mau dialihkan, clicked change dest di-reset jd false
                    data.clickToChangeDestQty(false);
                  },
                );
              }
            ),
          ),
        ],
      );
    }

    Widget formDestProduct() {
      return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKeys[2],
        child: Consumer<ShiftingStockProvider>(
            builder: (context, data, child){
              return TypeAheadFormField<ProductModel>(
                suggestionsCallback: (pattern) {
                  return SuggestionProductService().getDestinationProduct(
                    query: pattern,
                    sourceProductId: sourceProdId!,
                  );
                },
                validator: (value) {
                  if(data.sourceProductValue == true) {
                    if (value!.isEmpty) {
                      return 'Produk tujuan harus diisi';
                    } else if(data.validateDestProduct(value) == false) {
                      return 'Mohon pilih nama produk yang ada di daftar';
                    }
                    return null;
                  }
                  return null;
                },
                hideSuggestionsOnKeyboardHide: false,
                debounceDuration: const Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                    style: primaryTextStyle.copyWith(fontSize: 14),
                    controller: destinationProductController,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: const EdgeInsets.all(16),
                      fillColor: formColor,
                      hintText: 'Pilih/cari produk tujuan pengalihan',
                      hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                    ),
                  onEditingComplete: () {
                      formKeys[2].currentState!.validate()
                        ? (){}
                        : [data.setDestinationValue(false), FocusScope.of(context).unfocus()];
                  }
                ),
                onSuggestionSelected: (ProductModel suggestion) {
                  destinationProductController.text = suggestion.name;
                  destProdId = suggestion.id;
                  destSize = suggestion.size;
                  data.setDestinationValue(true);
                  //NOTE: saat pilih dest baru, clicked change dest qty di-reset jd false
                  data.clickToChangeDestQty(false);
                },
                itemBuilder: (context, ProductModel suggestion) {
                  return ListTile(
                    title: Text(suggestion.name, style: primaryTextStyle,),
                  );
                },
                errorBuilder: (context, error) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Tidak ada produk tujuan untuk produk asal yang dipilih',
                        style: alertTextStyle,
                      ),
                    ),
                  ),
                ),
                noItemsFoundBuilder: (context) => SizedBox(
                  height: 50,
                  child: Center(
                    child: Text(
                      'Produk tidak ditemukan',
                      style: greyTextStyle,
                    ),
                  ),
                )
            );
          }
        ),
      );
    }

    Widget destinationProduct(){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama produk tujuan',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Consumer<ShiftingStockProvider>(
            builder: (context, data, child) {
              if(data.sourceProductValue == true) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8,),
                    formDestProduct(),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mohon isi produk asal dengan benar terlebih dulu',
                      style: secondaryTextStyle.copyWith(
                        fontSize: 12
                      ),
                    ),
                    const SizedBox(height: 8,),
                    const TextFormFieldWidget(
                      hintText: 'Pilih/cari produk tujuan pengalihan',
                      readOnly: true,
                    )
                  ],
                );
              }
            }
          ),
        ],
      );
    }

    Widget showFormEditQty(ShiftingStockProvider data) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Ubah jumlah tujuan', style: primaryTextStyle,),
                const SizedBox(width: 20,),
                InkWell(
                  child: Ink(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xffe5e5e2)
                    ),
                    child: Text(
                      'Reset',
                      style: greyTextStyle,
                    ),
                  ),
                  onTap: () {
                    //NOTE: saat klik reset, nilai dest qty akan dikembalikan spt semula
                    data.setInitDestQty(destRoundQty!);
                  },
                ),
                const SizedBox(width: 16,),
                InkWell(
                  child: Ink(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xfff8e3e3)
                    ),
                    child: Text(
                      'Batal',
                      style: alertTextStyle,
                    ),
                  ),
                  onTap: () {
                    //NOTE: saat klik batal utk ubah nilai dest qty,
                    //clicked change akan di-reset jd false & nilai dest qty dikembalikan spt semula
                    data.clickToChangeDestQty(false);
                    data.setInitDestQty(destRoundQty!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: secondaryTextColor.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(
                        Icons.remove_circle,
                        color: data.destQtyToChange > 1
                            ? secondaryColor
                            : secondaryTextColor,
                    ),
                    iconSize: 28,
                    onPressed: () {
                      if(data.destQtyToChange > 1) {
                        //NOTE: jika destQty nilainya lebih dr 1, maka masih bisa dikurangi
                        data.reduceDestQty();
                      } else {
                        return;
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(data.destQtyToChange.toString()),
                  ),
                  IconButton(
                    iconSize: 28,
                    onPressed: () {
                      //NOTE: tambah nilai destQty
                      data.addDestQty();
                    },
                    icon: Icon(Icons.add_circle, color: secondaryColor,),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget editQtyManual() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  Perhitungan sistem kurang pas?',
            style: primaryTextStyle.copyWith(
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 2,),
          Consumer<ShiftingStockProvider>(
            builder: (context, data, child) {
              if (data.clickChangeDestQty) {
                return showFormEditQty(data);
              } else {
                return TextButton(
                  onPressed: () {
                    //NOTE: kalau owner klik ubah jml tujuan, clicked change jd bernilai true
                    //dan destQty akan diset nilainya dgn hasil perhitungan sistem
                    data.clickToChangeDestQty(true);
                    data.setInitDestQty(destRoundQty!);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 1),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                              color: priceColor,
                              width: 1.0,
                            )
                        )
                    ),
                    child: Text(
                        'Klik di sini untuk ubah jumlah tujuan',
                        style: priceTextStyle
                    ),
                  ),
                );
              }
            }
          ),
        ],
      );
    }

    Widget notes(ShiftingStockProvider data) {
      if(data.sourceProductValue == true &&
          (shiftQtyController.text.isNotEmpty && data.qtyShiftValue == true) &&
          (destinationProductController.text.isNotEmpty && data.destProductValue == true)
      ) {
          double destQty = int.tryParse(shiftQtyController.text)! * sourceSize! * (1/destSize!);
          destRoundQty = destQty.round();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xffFFEDCB),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan',
                      style: primaryTextStyle.copyWith(
                          fontWeight: semiBold
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Stok produk asal (${sourceProductController.text}) akan berkurang '
                          'sebanyak ${shiftQtyController.text} buah.',
                      style: primaryTextStyle,
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'Stok ${destinationProductController.text} jadi bertambah '
                          'sebanyak $destRoundQty buah.',
                      style: primaryTextStyle,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              editQtyManual(),
            ],
          );
        } else {
          return const SizedBox();
        }
    }

    Widget content() {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sourceProduct(),
            const SizedBox(height: 20,),
            shiftQty(),
            const SizedBox(height: 20,),
            destinationProduct(),
            const SizedBox(height: 20,),
            Consumer<ShiftingStockProvider>(
              builder: (context, data, child){
                return notes(data);
              }
            ),
            const SizedBox(height: 45,),
            SizedBox(
              width: double.infinity,
              child: Consumer<ShiftingStockProvider>(
                builder: (context, data, child){
                  return DoneButton(
                    onClick: () {
                      bool allIsValidated = formKeys.every((key) => key.currentState!.validate());
                      if(allIsValidated){
                        handleAddData();
                      }
                    },
                  );
                }
              ),
            ),
            const SizedBox(height: 20,),
          ],
        )
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Tambah Pengalihan Stok'),
      body: content(),
    );
  }
}
