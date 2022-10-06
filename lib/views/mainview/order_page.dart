import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../theme.dart';
import '../widgets/reusable/done_button.dart';
import '../widgets/transaction_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController searchController = TextEditingController(text: '');
  List<String> shippingTypeList = [
    'Semua',
    'Pesan Antar',
    'Ambil Mandiri',
  ];
  String selectedType = 'Semua';
  String? shippingTypeSelected;
  bool searchStatusFilled = false;

  String? searchQuery;
  var controller = ScrollController();
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    getInit();
    controller.addListener(() {
      if(controller.offset >= controller.position.maxScrollExtent && !controller.position.outOfRange) {
        if(transactionProvider.endPage > 1) {
          transactionProvider.getNextPageTransaction(shippingType: shippingTypeSelected, searchQuery: searchQuery);
        }
      }
    });
  }

  getInit() async {
    await transactionProvider.getTransactions(shippingType: null, searchQuery: null);
    await transactionProvider.pusherTransactionStatus();
    transactionProvider.filterTransactionStatus();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    transactionProvider.disposePage();
    transactionProvider.resetAllFilter();
  }

  @override
  Widget build(BuildContext context) {
    reloadGetTransactions() {
      transactionProvider.getTransactions(
          shippingType: shippingTypeSelected,
          searchQuery: searchController.text,
      );
      transactionProvider.disposePage();
    }

    Widget selectedFilterLabel() {
      List<String> selectedFilters = context.read<TransactionProvider>().labelSelectedStatusShown;
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 12),
        child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: 'Menampilkan daftar pesanan ',
                    style: primaryTextStyle.copyWith(fontSize: 13)
                ),
                selectedType != 'Semua'
                    ? TextSpan(
                    text: 'metode $selectedType ',
                    style: priceTextStyle.copyWith(fontSize: 13)
                )
                    : const TextSpan(),
                TextSpan(
                    text: 'dengan status ',
                    style: primaryTextStyle.copyWith(fontSize: 13)
                ),
                TextSpan(
                    children: selectedFilters.map((data) {
                      return TextSpan(
                          text: '"$data" ',
                          style: priceTextStyle.copyWith(fontSize: 13)
                      );
                    }).toList()
                )
              ]
          ),
        ),
      );
    }

    //Get data berdasarkan shipping type (semua, ambil mandiri, atau pesan antar)
    Widget shippingTypeOptions() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: shippingTypeList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = shippingTypeList[index];
                    if(selectedType == 'Semua') {
                      shippingTypeSelected = null;
                    } else {
                      shippingTypeSelected = selectedType;
                    }
                  });
                  context.read<TransactionProvider>().filterStatusShown(selectedType);
                  reloadGetTransactions();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  margin: const EdgeInsets.only(right: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: shippingTypeList[index] == selectedType ? thirdColor : secondaryTextColor.withOpacity(0.7),
                    ),
                    color: shippingTypeList[index] == selectedType ? fourthColor.withOpacity(0.4) : transparentColor,
                  ),
                  child: Center(
                    child: Text(
                        shippingTypeList[index],
                        style: shippingTypeList[index] == selectedType ?
                        priceTextStyle.copyWith(
                          fontSize: 13,
                        )
                            : greyTextStyle.copyWith(
                          fontSize: 13,
                        )
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    void clearSearch() {
      searchController.clear();
      searchQuery = null;
      setState(() {
        searchStatusFilled = false;
      });
      reloadGetTransactions();
    }

    Widget search() {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: 20,
            left: 20,
            right: 20
        ),
        child: TextFormField(
          style: primaryTextStyle.copyWith(fontSize: 14),
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: secondaryTextColor),
            ),
            hintText: 'Cari kode nota/produk/pembeli',
            hintStyle: secondaryTextStyle.copyWith(fontSize: 13),
            prefixIcon: Icon(Icons.search, color: secondaryTextColor, size: 20,),
            suffixIcon: searchStatusFilled
                ? InkWell(
                onTap: () {
                  clearSearch();
                },
                child: Icon(Icons.cancel, color: secondaryTextColor, size: 20,))
                : null,
            contentPadding: const EdgeInsets.all(12),
          ),
          onFieldSubmitted: (value) {
            context.read<TransactionProvider>().getTransactions(
                shippingType: shippingTypeSelected,
                searchQuery: value,
            );
            context.read<TransactionProvider>().disposePage();
            if(value.isNotEmpty) {
              setState(() {
                searchStatusFilled = true;
                searchQuery = value;
              });
            } else {
              setState(() {
                searchStatusFilled = false;
                searchQuery = null;
              });
            }
          },
        ),
      );
    }

    //================================ FILTER ==================================
    listFilterStatus() {
      return Consumer<TransactionProvider>(
          builder: (context, transProv, child) {
            List<String> filterTitle = transProv.transactionStatus.map((e) => e.title).toList();
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: transProv.transactionStatus.length,
                itemBuilder: (context, index) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return CheckboxListTile(
                        activeColor: primaryColor,
                        onChanged: (bool? value) {
                          setModalState(() {
                            transProv.transactionStatus[index].value = value!;
                          });

                          if(transProv.transactionStatus[index].value == true) {
                            transProv.addToFilterStatus(transProv.transactionStatus[index]);
                          } else {
                            transProv.removeFilterStatus(transProv.transactionStatus[index]);
                          }
                        },
                        value: transProv.transactionStatus[index].value,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(
                          filterTitle[index],
                          style: primaryTextStyle.copyWith(fontSize: 14),
                        ),
                      );
                    },
                  );
                }
            );
          }
      );
    }

    Future<void> showModalFilter() {
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Filter Status Pesanan',
                                style: primaryTextStyle.copyWith(fontWeight: semiBold, fontSize: 14),
                              ),
                              shippingTypeSelected != null
                                  ? Text(
                                'Khusus Metode $shippingTypeSelected',
                                style: greyTextStyle.copyWith(fontSize: 12),
                              )
                                  : const SizedBox(),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              transactionProvider.resetAllFilter();
                            },
                            child: Text(
                              'Reset Filter',
                              style: blueTextStyle.copyWith(decoration: TextDecoration.underline, fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12,),
                    listFilterStatus(),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - defaultMargin*2,
                      child: DoneButton(
                        fontSize: 14,
                        text: 'Terapkan Filter',
                        onClick: () {
                          //harus pakai setState supaya muncul loadingnya
                          setState(() {
                            reloadGetTransactions();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                )
            )
        ),
      );
    }

    Widget filterBtn() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 2),
        child: GestureDetector(
          onTap: () {
            showModalFilter();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: thirdColor,
            ),
            padding: const EdgeInsets.all(10),
            child: Image.asset('assets/filter_icon.png', width: 24, color: Colors.white,)
          ),
        ),
      );
    }
    //==========================================================================

    Widget loadingWidget() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget emptyDataWidget() {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width - (10 * defaultMargin),),
              Text(
                'Pencarian transaksi tidak ditemukan',
                textAlign: TextAlign.center,
                style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 16),
              )
            ],
          ),
        ),
      );
    }

    Widget historyData(TransactionProvider data) {
      return ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: data.transactions.length + 1,
        itemBuilder: (context, index) {
          if(index < data.transactions.length) {
            TransactionModel transactions = data.transactions[index];
            return TransactionCard(transactions: transactions, transactionProvider: data);
          } else {
            return data.noMoreData
                ? const SizedBox()
                : Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Memuat lebih banyak...',
                  style: greyTextStyle.copyWith(fontSize: 14),
                ),
              ),
            );
          }
        },
      );
    }

    Widget content() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shippingTypeOptions(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              filterBtn(),
              Flexible(child: search())
            ],
          ),
          context.read<TransactionProvider>().labelSelectedStatusShown.isNotEmpty
            ? selectedFilterLabel()
            : const SizedBox(),
          Flexible(
              child: Consumer<TransactionProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                    child: data.loadingGetData
                      ? loadingWidget()
                      : data.transactions.isEmpty
                        ? emptyDataWidget()
                        : historyData(data)
                  );
                },
              )
          ),
        ],
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Daftar Pesanan'),
      body: content(),
    );
  }
}