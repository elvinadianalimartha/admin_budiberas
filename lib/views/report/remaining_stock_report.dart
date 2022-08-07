import 'package:budiberas_admin_9701/models/report_remaining_stock_model.dart';
import 'package:budiberas_admin_9701/providers/report_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RemainingStockReportPage extends StatefulWidget {
  const RemainingStockReportPage({Key? key}) : super(key: key);

  @override
  State<RemainingStockReportPage> createState() => _RemainingStockReportPageState();
}

class _RemainingStockReportPageState extends State<RemainingStockReportPage> {
  String chosenDate = '';
  TextEditingController searchController = TextEditingController(text: DateFormat('dd MMMM yyyy', 'id').format(DateTime.now()));

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    chosenDate = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    await Provider.of<ReportProvider>(context, listen: false).reportRemainingStock(chosenDate: chosenDate);
  }

  @override
  Widget build(BuildContext context) {
    ReportProvider reportProvider = Provider.of<ReportProvider>(context);

    Widget calendar() {
      return Container(
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
                    hintText: 'Pilih tanggal',
                    hintStyle: secondaryTextStyle.copyWith(fontSize: 14)
                ),
              ),
            ),
            GestureDetector(
                onTap: () async{
                  DateTime? pickDate = await showDatePicker(
                    locale: const Locale('id', ''),
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),
                    lastDate: DateTime(2100),
                  );

                  if (pickDate == null) return;

                  String formattedDate = DateFormat('dd MMMM yyyy', 'id').format(pickDate);
                  String changeChosenDate = DateFormat('yyyy-MM-dd', 'id').format(pickDate);

                  searchController.text = formattedDate;
                  reportProvider.remainingStocks = [];
                  reportProvider.reportRemainingStock(chosenDate: changeChosenDate);
                },
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: secondaryTextColor,
                  size: 24,)
            ),
          ],
        ),
      );
    }

    Widget note(){
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffFFEDCB),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📌  Catatan',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 8,),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Stok awal: stok saat jam ',
                    style: primaryTextStyle
                  ),
                  TextSpan(
                      text: '07.00',
                      style: priceTextStyle
                  )
                ]
              )
            ),
            const SizedBox(height: 4,),
            RichText(
              text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'Stok akhir: stok saat jam ',
                        style: primaryTextStyle
                    ),
                    TextSpan(
                        text: '17.00',
                        style: priceTextStyle
                    )
                  ]
              )
            ),
          ],
        ),
      );
    }

    Widget textInTable({
      required String text1, text2, text3,
      required TextStyle textStyle
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              text1,
              style: textStyle,
            ),
          ),
          const SizedBox(width: 30,),
          SizedBox(
            width: 70,
            child: Text(
              text2,
              style: textStyle,
            ),
          ),
          const SizedBox(width: 20,),
          Flexible(
            child: Text(
              text3,
              style: textStyle,
            ),
          ),
        ],
      );
    }

    Widget tableColumnName() {
      return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: textInTable(
              text1: 'Produk',
              text2: 'Stok Awal',
              text3: 'Stok Akhir',
              textStyle: primaryTextStyle.copyWith(fontWeight: semiBold)
          )
      );
    }

    Widget buildTile(ReportRemainingStockModel remainingStock) {
      return ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        title: textInTable(
            text1: remainingStock.productName,
            text2: '${remainingStock.initStock}',
            text3: '${remainingStock.endStock}',
            textStyle: primaryTextStyle.copyWith(fontSize: 14)
        ),
        children: [
          remainingStock.detail.qtyIncomingStock > 0
          ? Text(
              '+${remainingStock.detail.qtyIncomingStock} karena stok masuk',
              style: priceTextStyle,
            )
          : const SizedBox(),

          remainingStock.detail.qtyShiftDestination > 0
          ? Text(
              '+${remainingStock.detail.qtyShiftDestination} karena dapat stok pengalihan',
              style: priceTextStyle,
            )
          : const SizedBox(),

          remainingStock.detail.qtyTransaction > 0
          ? Text(
              '-${remainingStock.detail.qtyTransaction} karena transaksi',
              style: alertTextStyle,
            )
          : const SizedBox(),

          remainingStock.detail.qtyOutStock > 0
          ? Text(
              '-${remainingStock.detail.qtyOutStock} karena retur ke supplier',
              style: alertTextStyle,
            )
          : const SizedBox(),

          remainingStock.detail.qtyShiftSource > 0
          ? Text(
              '-${remainingStock.detail.qtyShiftSource} karena stoknya dialihkan',
              style: alertTextStyle,
            )
          : const SizedBox(),
        ]
      );
    }

    Widget content() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                tableColumnName(),
                const Divider(thickness: 1,),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: reportProvider.remainingStocks.map(buildTile).toList(),
                ),
              ],
            )
        ),
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

    return Scaffold(
      appBar: customAppBar(text: 'Laporan Sisa Stok'),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                calendar(),
                const SizedBox(height: 20,),
                note(),
                const SizedBox(height: 20,),
                reportProvider.loadingRemainingStock
                    ? loadingWidget()
                    : content()
              ],
            ),
          )
      ),
    );
  }
}
