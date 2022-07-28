import 'package:budiberas_admin_9701/models/out_stock_model.dart';
import 'package:budiberas_admin_9701/providers/out_stock_provider.dart';
import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/services/suggestion_product_service.dart';
import 'package:budiberas_admin_9701/views/widgets/return_to_supplier_card.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../theme.dart';
import '../widgets/reusable/add_button.dart';
import '../widgets/reusable/cancel_button.dart';
import '../widgets/reusable/done_button.dart';
import '../widgets/reusable/line_text_field.dart';

class ReturnToSupplierPage extends StatefulWidget {
  const ReturnToSupplierPage({Key? key}) : super(key: key);

  @override
  _ReturnToSupplierPageState createState() => _ReturnToSupplierPageState();
}

class _ReturnToSupplierPageState extends State<ReturnToSupplierPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController(text: '');

  TextEditingController chooseProductController = TextEditingController(text: '');
  int productId = 0;
  int? maxOutQty;

  TextEditingController outQtyController = TextEditingController(text: '');

  @override
  void initState() {
    getInit();
    super.initState();
  }

  void getInit() async{
    await Future.wait([
      Provider.of<OutStockProvider>(context, listen: false).getOutStocks(),
      Provider.of<ProductProvider>(context, listen: false).getProducts(),
    ]);
  }

  @override
  void dispose() {
    searchController.dispose();
    chooseProductController.dispose();
    productId = 0;
    maxOutQty = 0;
    outQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    handleCreateData(OutStockProvider outStockProvider) async {
      if(await outStockProvider.createOutStock(
        productId: productId,
        quantity: int.parse(outQtyController.text),
      )) {
        Navigator.pop(context);
        productId = 0;
        chooseProductController.clear();
        outQtyController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data retur ke supplier berhasil tersimpan'), backgroundColor: secondaryColor, duration: const Duration(seconds: 2),),
        );
        outStockProvider.getOutStocks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Data gagal ditambahkan'), backgroundColor: alertColor, duration: const Duration(seconds: 2),),
        );
      }
    }

    Future<void> showModalAdd() {
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
          child: SingleChildScrollView(
            //mainAxisSize: MainAxisSize.min,
            child:
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catat Retur ke Supplier',
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      'Produk',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 13,
                      ),
                    ),
                    Consumer<ProductProvider>(
                      builder: (context, data, child) {
                        return TypeAheadFormField<ProductModel>(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Produk harus diisi!';
                              } else if(data.checkIfUsed(value) == false) {
                                return 'Mohon pilih nama produk yang ada di daftar';
                              }
                              return null;
                            },
                            hideSuggestionsOnKeyboardHide: false,
                            debounceDuration: const Duration(milliseconds: 500),
                            textFieldConfiguration: TextFieldConfiguration(
                                style: primaryTextStyle,
                                controller: chooseProductController,
                                decoration: InputDecoration(
                                  hintText: 'Pilih/cari produk',
                                  hintStyle: secondaryTextStyle,
                                ),
                                onEditingComplete: (){},
                            ),
                            onSuggestionSelected: (ProductModel suggestion) {
                              chooseProductController.text = suggestion.name;
                              productId = suggestion.id;
                              maxOutQty = suggestion.stock;
                            },
                            itemBuilder: (context, ProductModel suggestion) {
                              return ListTile(
                                title: Text(suggestion.name, style: primaryTextStyle,),
                              );
                            },
                            suggestionsCallback: (pattern) {
                              return SuggestionProductService().getAvailableStockProduct(pattern);
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
                    const SizedBox(height: 30,),
                    Text(
                      'Jumlah retur',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2,),
                    chooseProductController.text == '' || maxOutQty == null
                      ? const SizedBox()
                      : Text(
                        'Maksimal $maxOutQty buah',
                        style: priceTextStyle.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    LineTextField(
                      readOnly: chooseProductController.text == ''
                                ? true
                                : false,
                      hintText: 'Masukkan jumlah retur',
                      actionKeyboard: TextInputAction.done,
                      textInputType: TextInputType.number,
                      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                      controller: outQtyController,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Jumlah harus diisi!';
                        } else if(int.parse(value) <= 0) {
                          return 'Jumlah harus lebih dari 0!';
                        } else if(int.parse(value) > maxOutQty!) {
                          return 'Jumlah retur tidak bisa melebihi stok produk ($maxOutQty buah)';
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
                                chooseProductController.clear();
                                outQtyController.clear();
                              }
                          ),
                        ),
                        Consumer<OutStockProvider>(
                            builder: (context, outStockProvider, child){
                              return SizedBox(
                                width: 150,
                                child: DoneButton(
                                    text: 'Simpan',
                                    onClick: () {
                                      if(_formKey.currentState!.validate()) {
                                        handleCreateData(outStockProvider);
                                      }
                                    }
                                ),
                              );
                            }
                        ),
                      ],
                    ),
                    const SizedBox(height: 36,),
                  ],
                ),
              ),
          ),
        ),
      );
    }

    Widget btnAddStock() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
              width: 180,
              child: AddButton(
                  onClick: () {
                    showModalAdd();
                  },
                  icon: Icons.add_circle_outlined,
                  text: 'Tambah Data'
              )
          ),
        ),
      );
    }

    Widget search() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: secondaryTextColor.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: primaryTextStyle,
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration.collapsed(
                      enabled: false,
                      hintText: 'Cari stok keluar per tanggal',
                      hintStyle: secondaryTextStyle.copyWith(fontSize: 14)
                  ),
                ),
              ),
              Consumer<OutStockProvider>(
                  builder: (context, data, child) {
                    return Row(
                      children: [
                        searchController.text.isNotEmpty
                          ? TextButton(
                            onPressed: () {
                              searchController.clear();
                              data.searchOutStock(null);
                            },
                            child: Text(
                              'Reset',
                              style: priceTextStyle.copyWith(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )
                          : const SizedBox(),
                        const SizedBox(width: 20,),
                        GestureDetector(
                            onTap: () async {
                              DateTime? chosenDate = await showDatePicker(
                                locale: const Locale('id', ''),
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2100),
                              );

                              if(chosenDate == null) return;

                              String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(chosenDate);

                              searchController.text = formattedDate;
                              data.searchOutStock(chosenDate);
                            },
                            child: Icon(
                              Icons.calendar_today_outlined,
                              color: secondaryTextColor,
                              size: 24,)
                        ),
                      ],
                    );
                  }
              ),
            ],
          ),
        ),
      );
    }

    Widget content() {
      return Column(
        children: [
          btnAddStock(),
          search(),
          const SizedBox(height: 20,),
          Flexible(
            child: Consumer<OutStockProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                    child: data.loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                        )
                        :
                        data.outStocks.isEmpty
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 50,),
                                Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width - (10 * defaultMargin),),
                                Text(
                                  'Data masih kosong',
                                  style: primaryTextStyle.copyWith(
                                      fontWeight: medium,
                                      fontSize: 18),
                                )
                              ],
                            ),
                        )
                        : ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.outStocks.length,
                        itemBuilder: (context, index) {
                          OutStockModel outStocks = data.outStocks[index];
                          return ReturnToSupplierCard(outStocks: outStocks, outStockProvider: data,);
                        }
                    ),
                  );
                }
            ),
          )
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
        context.read<OutStockProvider>().searchOutStock(null);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: customAppBar(
            text: 'Kelola Retur ke Supplier'
        ),
        body: content(),
      ),
    );
  }
}