import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../theme.dart';
import '../widgets/transaction_card.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TextEditingController searchController = TextEditingController(text: '');
  List<String> typeList = [
    'Semua',
    'Pesan Antar',
    'Ambil Mandiri',
  ];
  String selectedType = 'Semua';
  String? typeToFilter;
  bool searchStatusFilled = false;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<TransactionProvider>(context, listen: false).getTransactions(shippingType: null, searchQuery: null);
    await Provider.of<TransactionProvider>(context, listen: false).pusherTransactionStatus();
  }

  @override
  Widget build(BuildContext context) {
    Widget shippingTypeOptions() {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: typeList.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedType = typeList[index];
                    if(selectedType == 'Semua') {
                      typeToFilter = null;
                    } else {
                      typeToFilter = selectedType;
                    }
                  });
                  context.read<TransactionProvider>().getTransactions(shippingType: typeToFilter, searchQuery: searchController.text);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: typeList[index] == selectedType ? thirdColor : secondaryTextColor.withOpacity(0.7),
                    ),
                    color: typeList[index] == selectedType ? fourthColor.withOpacity(0.4) : transparentColor,
                  ),
                  child: Center(
                    child: Text(
                        typeList[index],
                        style: typeList[index] == selectedType ?
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
      setState(() {
        searchStatusFilled = false;
      });
      context.read<TransactionProvider>().getTransactions(shippingType: typeToFilter, searchQuery: null);
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
            hintText: 'Cari nama pembeli/produk/kode nota',
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
          onChanged: (value) {
            Future.delayed(const Duration(milliseconds: 500), () {
              //context.read<TransactionProvider>().transactions = [];
              context.read<TransactionProvider>().getTransactions(shippingType: typeToFilter, searchQuery: value);
            });
            if(value.isNotEmpty) {
              setState(() {
                searchStatusFilled = true;
              });
            } else {
              setState(() {
                searchStatusFilled = false;
              });
            }
          },
        ),
      );
    }

    Widget loadingWidget() {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget emptyDataWidget() {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50,),
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
      );
    }

    Widget content() {
      return Column(
        children: [
          shippingTypeOptions(),
          search(),
          const SizedBox(height: 8,),
          Flexible(
              child: Consumer<TransactionProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                      child: data.loadingGetData
                          ? loadingWidget()
                          : data.transactions.isEmpty
                          ? emptyDataWidget()
                          : ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.transactions.length,
                        itemBuilder: (context, index) {
                          TransactionModel transactions = data.transactions[index];
                          return TransactionCard(transactions: transactions, transactionProvider: data,);
                        },
                      )
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