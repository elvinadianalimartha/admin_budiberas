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
  int? sourceProdId;
  int? destProdId;

  late ShiftingStockProvider shiftingStockProvider;

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
                        style: primaryTextStyle,
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
                          hintStyle: secondaryTextStyle,
                        ),
                        onEditingComplete: (){
                          formKeys[0].currentState!.validate()
                            ? data.sourceIsSet() //NOTE: product source akan diset true kalau sudah lolos validasi
                            : [data.sourceIsNotSet(),
                              sourceProdId = null,
                              shiftQtyController.clear(),
                              destinationProductController.clear(),
                              FocusScope.of(context).unfocus(),];
                        }
                    ),
                    onSuggestionSelected: (ProductModel suggestion) {
                      sourceProductController.text = suggestion.name;
                      sourceProdId = suggestion.id;
                      data.getDestProductSuggestions('',sourceProdId!);
                      data.setMaxShiftQty(suggestion.stock);
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
              return data.isSourceProductSet == true
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
                  readOnly: data.isSourceProductSet ? false : true, //kalau set source product salah, maka readOnlynya true
                  validator: (value) {
                    if(data.isSourceProductSet) {
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
                  if(data.isSourceProductSet) {
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
                    style: primaryTextStyle,
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
                      hintStyle: secondaryTextStyle,
                    )
                ),
                onSuggestionSelected: (ProductModel suggestion) {
                  destinationProductController.text = suggestion.name;
                  destProdId = suggestion.id;
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
                      sourceProductController.text == '' || data.isSourceProductSet == false
                          ? 'Mohon isi produk asal dgn benar terlebih dulu'
                          : 'Terjadi kesalahan, mohon ulangi pencarian',
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
              if(data.isSourceProductSet == true) {
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
            const SizedBox(height: 50,),
            SizedBox(
              width: double.infinity,
              child: Consumer<ShiftingStockProvider>(
                builder: (context, data, child){
                  return DoneButton(
                    onClick: () {
                      bool allIsValidated = formKeys.every((key) => key.currentState!.validate());
                      if(allIsValidated){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Data berhasil ditambahkan'),
                            backgroundColor: secondaryColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                }
              ),
            ),
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
