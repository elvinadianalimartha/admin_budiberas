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
  final _formKey = GlobalKey<FormState>();
  TextEditingController sourceProductController = TextEditingController(text: '');
  TextEditingController shiftQtyController = TextEditingController(text: '');
  TextEditingController destinationProductController = TextEditingController(text: '');
  int? sourceProdId;
  int? destProdId;
  int maxShiftQty = 0;

  @override
  void initState() {
    //getInit();
    super.initState();
  }

  @override
  void dispose() {
    sourceProductController.clear();
    shiftQtyController.clear();
    maxShiftQty = 0;
    super.dispose();
  }

  // void getInit(){
  //   Provider.of<ShiftingStockProvider>(context, listen: false);
  // }

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
          Consumer<ShiftingStockProvider>(
            builder: (context, data, child){
              return TypeAheadFormField<ProductModel>(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Produk asal harus diisi!';
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
                      )
                  ),
                  onSuggestionSelected: (ProductModel suggestion) {
                    sourceProductController.text = suggestion.name;
                    sourceProdId = suggestion.id;
                    data.setMaxShiftQty(suggestion.stock);
                  },
                  itemBuilder: (context, ProductModel suggestion) {
                    return ListTile(
                      title: Text(suggestion.name, style: primaryTextStyle,),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return SuggestionProductService().getCanBeRetailedProduct(pattern);
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
                return Text(
                  'Maksimal ${data.maxQty} buah',
                  style: priceTextStyle.copyWith(
                      fontSize: 12
                  ),
                );
              }
          ),
          // sourceProductController.text.isEmpty
          // ? const SizedBox()
          // : Consumer<ShiftingStockProvider>(
          //     builder: (context, data, child) {
          //       return Text(
          //         'Maksimal ${data.maxQty} buah',
          //         style: priceTextStyle.copyWith(
          //           fontSize: 12
          //         ),
          //       );
          //     }
          //   ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: 'Masukkan jumlah yang mau dialihkan',
            controller: shiftQtyController,
            textInputType: TextInputType.number,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Jumlah pengalihan harus diisi';
              } else if(int.parse(value) > maxShiftQty) {
                return 'Jumlah pengalihan maksimal $maxShiftQty!';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget destinationProduct(){
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
          TypeAheadFormField<ProductModel>(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Produk tujuan harus diisi!';
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
              suggestionsCallback: (pattern) {
                return SuggestionProductService().getDestinationProduct(
                  query: pattern,
                  sourceProductId: sourceProdId!,
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
            const SizedBox(height: 36,),
            SizedBox(
              width: double.infinity,
              child: DoneButton(
                onClick: () {

                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Tambah Pengalihan Stok'),
      body: content(),
    );
  }
}
