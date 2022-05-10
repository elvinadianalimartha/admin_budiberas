import 'package:budiberas_admin_9701/models/incoming_stock_model.dart';
import 'package:budiberas_admin_9701/providers/incoming_stock_provider.dart';
import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/services/product_service.dart';
import 'package:budiberas_admin_9701/views/widgets/incoming_stocks_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../theme.dart';
import '../widgets/reusable/add_button.dart';
import '../widgets/reusable/app_bar.dart';

import '../widgets/reusable/cancel_button.dart';
import '../widgets/reusable/done_button.dart';
import '../widgets/reusable/line_text_field.dart';

class IncomingStock extends StatefulWidget {
  const IncomingStock({Key? key}) : super(key: key);

  @override
  _IncomingStockState createState() => _IncomingStockState();
}

class _IncomingStockState extends State<IncomingStock> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchAddedController = TextEditingController(text: '');
  TextEditingController searchReturnController = TextEditingController(text: '');

  TextEditingController chooseAddedProductController = TextEditingController(text: '');
  TextEditingController chooseReturnProductController = TextEditingController(text: '');

  TextEditingController addedQtyController = TextEditingController(text: '');
  TextEditingController returnQtyController = TextEditingController(text: '');

  String status = '';
  //late TabController _tabController;

  final List<Tab> listTab = const [
    Tab(text: 'Tambah Stok'),
    Tab(text: 'Retur dari Pembeli'),
  ];

  @override
  void initState() {
    super.initState();
    getInit();
  }

  void getInit() async {
    await Future.wait([
      Provider.of<IncomingStockProvider>(context, listen: false).getIncomingStocks(statusParam: 'Tambah stok'),
      Provider.of<IncomingStockProvider>(context, listen: false).getIncomingStocks(statusParam: 'Retur dari pembeli')
    ]);
  }

  //dispose ketika sudah gaada di page ini lg
  @override
  void dispose() {
    //_tabController.dispose();
    status = '';
    searchAddedController.dispose();
    searchReturnController.dispose();
    chooseAddedProductController.dispose();
    chooseReturnProductController.dispose();
    addedQtyController.dispose();
    returnQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build incoming stock page');

    Future<void> showModalAdd({required String statusName}) {
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
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusName == 'Retur dari pembeli' ? 'Catat Retur dari Pembeli' : 'Tambah Stok',
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
                    TypeAheadFormField<ProductModel>(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Produk harus diisi!';
                        }
                        return null;
                      },
                      hideSuggestionsOnKeyboardHide: false,
                      debounceDuration: const Duration(milliseconds: 500),
                      textFieldConfiguration: TextFieldConfiguration(
                        style: primaryTextStyle,
                        controller: statusName == 'Retur dari pembeli'
                            ? chooseReturnProductController
                            : chooseAddedProductController,
                        decoration: InputDecoration(
                          hintText: 'Pilih/cari produk',
                          hintStyle: secondaryTextStyle,
                        )
                      ),
                      onSuggestionSelected: (ProductModel suggestion) {
                        statusName == 'Retur dari pembeli'
                          ? chooseReturnProductController.text = suggestion.name
                          : chooseAddedProductController.text = suggestion.name;
                      },
                      itemBuilder: (context, ProductModel suggestion) {
                        return ListTile(
                          title: Text(suggestion.name, style: primaryTextStyle,),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        return ProductService().getSuggestionProduct(pattern);
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
                    const SizedBox(height: 30,),
                    Text(
                      'Jumlah masuk',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 13,
                      ),
                    ),
                    LineTextField(
                      hintText: 'Masukkan jumlah stok masuk',
                      actionKeyboard: TextInputAction.done,
                      controller: statusName == 'Retur dari pembeli'
                          ? returnQtyController
                          : addedQtyController,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Jumlah harus diisi!';
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
                                if(statusName == 'Retur dari pembeli') {
                                  chooseReturnProductController.clear();
                                  returnQtyController.clear();
                                } else if(statusName == 'Tambah stok') {
                                  chooseAddedProductController.clear();
                                  addedQtyController.clear();
                                }
                              }
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: DoneButton(
                              text: 'Simpan',
                              onClick: () {
                                if(_formKey.currentState!.validate()) {

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

    Widget btnAddStock({required String statusName}) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
              width: 150,
              child: AddButton(
                  onClick: () {
                    showModalAdd(statusName: statusName);
                  },
                  icon: Icons.add_circle_outlined,
                  text: statusName == 'Tambah stok'
                      ? 'Tambah Stok'
                      : 'Catat Retur'
              )
          ),
        ),
      );
    }

    Widget search({required String statusName}) {
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
                    controller: statusName == 'Tambah stok'
                          ? searchAddedController
                          : searchReturnController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration.collapsed(
                      enabled: false,
                      hintText: 'Cari stok masuk per tanggal',
                      hintStyle: secondaryTextStyle
                    ),
                  ),
                ),
                Consumer<IncomingStockProvider>(
                  builder: (context, data, child) {
                    return Row(
                      children: [
                        statusName == 'Tambah stok' && searchAddedController.text.isNotEmpty
                          ? TextButton(
                              onPressed: () {
                                searchAddedController.clear();
                                data.searchAddedIncomingStock(null);
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

                        statusName == 'Retur dari pembeli' && searchReturnController.text.isNotEmpty
                          ? TextButton(
                            onPressed: () {
                              searchReturnController.clear();
                              data.searchReturnIncomingStock(null);
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

                            if(statusName == 'Tambah stok') {
                              searchAddedController.text = formattedDate;
                              data.searchAddedIncomingStock(chosenDate);
                            } else if(statusName == 'Retur dari pembeli') {
                              searchReturnController.text = formattedDate;
                              data.searchReturnIncomingStock(chosenDate);
                            }
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

    //Isi tab tambah stok
    Widget contentAddStock() {
      String statusName = 'Tambah stok';
      return Column(
        children: [
          btnAddStock(statusName: statusName),
          search(statusName: statusName),
          const SizedBox(height: 20,),
          Flexible(
            child: Consumer<IncomingStockProvider>(
              builder: (context, data, child) {
                return SizedBox(
                  child: data.loading
                  ? const Center(
                    child: CircularProgressIndicator(),
                  )
                  :
                  data.addedIncomingStocks.isEmpty
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
                        itemCount: data.addedIncomingStocks.length,
                        itemBuilder: (context, index) {
                          IncomingStockModel addedIncomingStocks = data.addedIncomingStocks[index];
                          return IncomingStocksCard(incomingStocks: addedIncomingStocks);
                        }
                      ),
                );
              }
            ),
          )
        ],
      );
    }

    //Isi tab retur dari pembeli
    Widget contentReturn() {
      String statusName = 'Retur dari pembeli';
      return Column(
        children: [
          btnAddStock(statusName: statusName),
          search(statusName: statusName),
          const SizedBox(height: 20,),
          Flexible(
            child: Consumer<IncomingStockProvider>(
              builder: (context, data, child) {
                return SizedBox(
                  child: data.loading
                  ? const Center(
                    child: CircularProgressIndicator(),
                  )
                  :
                  data.returnIncomingStocks.isEmpty
                    ? SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 50,),
                          Image.asset('assets/empty-icon.png', width: MediaQuery
                              .of(context)
                              .size
                              .width - (10 * defaultMargin),),
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
                      itemCount: data.returnIncomingStocks.length,
                      itemBuilder: (context, index) {
                        IncomingStockModel addedIncomingStocks = data.returnIncomingStocks[index];
                        return IncomingStocksCard(
                          incomingStocks: addedIncomingStocks
                        );
                      }
                  ),
                );
              }
            ),
          )
        ],
      );
    }

    Widget content() {
      return TabBarView(
        //controller: _tabController,
        children: [
          contentAddStock(),
          contentReturn(),
        ],
      );
    }

    return WillPopScope(
      onWillPop: () {
        context.read<IncomingStockProvider>().searchAddedIncomingStock(null);
        context.read<IncomingStockProvider>().searchReturnIncomingStock(null);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: customAppBar(
            text: 'Kelola Stok Masuk',
            bottom: TabBar(
              //controller: _tabController,
                labelColor: thirdColor,
                unselectedLabelColor: Colors.white,
                indicatorColor: secondaryColor,
                indicatorWeight: 4,
                labelStyle: whiteTextStyle.copyWith(fontSize: 15),
                tabs: listTab
            ),
          ),
          body: content(),
        ),
      ),
    );
  }
}
