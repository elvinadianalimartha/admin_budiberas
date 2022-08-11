import 'package:budiberas_admin_9701/models/report_monthly_model.dart';
import 'package:budiberas_admin_9701/providers/report_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MonthsOption {
  late int id;
  late String name;

  MonthsOption({required this.id, required this.name});
}

class MonthlyReportPage extends StatefulWidget {
  const MonthlyReportPage({Key? key}) : super(key: key);

  @override
  State<MonthlyReportPage> createState() => _MonthlyReportPageState();
}

class _MonthlyReportPageState extends State<MonthlyReportPage> {
  late int _chosenMonth;
  late String _currentYear;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    _chosenMonth = DateTime.now().month;
    _currentYear = DateTime.now().year.toString();
    await Provider.of<ReportProvider>(context, listen: false).reportMonthlySales(month: _chosenMonth.toString(), year: _currentYear);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController inputYear = TextEditingController(text: _currentYear);
    var formatter = NumberFormat.decimalPattern('id');
    ReportProvider reportProv = Provider.of<ReportProvider>(context);

    final listOfMonths = <MonthsOption>[
      MonthsOption(id: 1, name: 'Januari'),
      MonthsOption(id: 2, name: 'Februari'),
      MonthsOption(id: 3, name: 'Maret'),
      MonthsOption(id: 4, name: 'April'),
      MonthsOption(id: 5, name: 'Mei'),
      MonthsOption(id: 6, name: 'Juni'),
      MonthsOption(id: 7, name: 'Juli'),
      MonthsOption(id: 8, name: 'Agustus'),
      MonthsOption(id: 9, name: 'September'),
      MonthsOption(id: 10, name: 'Oktober'),
      MonthsOption(id: 11, name: 'November'),
      MonthsOption(id: 12, name: 'Desember'),
    ];

    Widget chooseMonth() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Bulan',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(height: 8,),
          SizedBox(
            width: 150,
            child: DropdownButtonFormField2<Object>(
              dropdownMaxHeight: 250,
              value: _chosenMonth,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
              items: listOfMonths.map((item) {
                return DropdownMenuItem<Object>(
                  child: Text(item.name, style: primaryTextStyle.copyWith(fontSize: 14),),
                  value: item.id,
                );
              }).toList(),
              onChanged: (value) {
                if(value.toString() != _chosenMonth.toString()) {
                  _chosenMonth = int.parse(value.toString());
                  reportProv.loadingMonthly = true;
                  reportProv.monthlySalesDetail = [];
                  reportProv.reportMonthlySales(month: _chosenMonth.toString(), year: _currentYear);
                }
              }
            ),
          ),
        ],
      );
    }

    Widget chooseYear() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tahun Laporan : ',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(height: 8,),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: inputYear,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4),],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(12)
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  _currentYear = value;
                });
                reportProv.reportMonthlySales(month: _chosenMonth.toString(), year: _currentYear);
              },
            ),
          ),
        ],
      );
    }

    Widget totalOmzet() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: fourthColor.withOpacity(0.4),
        child: Text(
          'Total omzet: Rp ${formatter.format(reportProv.monthlyOmzet)}',
          style: priceTextStyle.copyWith(fontWeight: semiBold, fontSize: 15),
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
          text1: 'Kategori',
          text2: 'Jumlah',
          text3: 'Subtotal',
          textStyle: primaryTextStyle.copyWith(fontWeight: semiBold)
        )
      );
    }

    Widget detailBuildTile(DetailReportMonthlyModel detailMonthlySale) {
      return ListTile(
        title: textInTable(
            text1: detailMonthlySale.productName,
            text2: '${detailMonthlySale.qtySold}',
            text3: 'Rp ${formatter.format(detailMonthlySale.totalSold)}',
            textStyle: greyTextStyle
        ),
      );
    }

    Widget buildTile(ReportMonthlyModel monthlySale) {
      return ExpansionTile(
        title: textInTable(
          text1: monthlySale.categoryName,
          text2: '${monthlySale.qtySold}',
          text3: 'Rp ${formatter.format(monthlySale.totalSold)}',
          textStyle: primaryTextStyle
        ),
        children: monthlySale.detailProduct.map(detailBuildTile).toList(),
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

    Widget emptyTransaction() {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Center(
            child: Column(
              children: [
                Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width/2.5,),
                const SizedBox(height: 12,),
                Text(
                  'Belum ada transaksi di bulan '
                      '${listOfMonths.where((e) => e.id == _chosenMonth).first.name} '
                      '$_currentYear',
                  style: primaryTextStyle.copyWith(fontSize: 16),
                )
              ],
            )
        ),
      );
    }

    Widget content() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: [
                tableColumnName(),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: reportProv.monthlySalesDetail.map(buildTile).toList(),
                ),
              ],
            )
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Laporan Penjualan Bulanan'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  chooseMonth(),
                  const SizedBox(width: 30,),
                  Flexible(
                    child: chooseYear(),
                  ),
                ],
              ),
              const SizedBox(height: 16,),
              totalOmzet(),
              const SizedBox(height: 16,),
              reportProv.loadingMonthly
                  ? loadingWidget()
                  : reportProv.monthlySalesDetail.isEmpty
                      ? emptyTransaction()
                      : content()
            ],
          ),
        )
      ),
    );
  }
}
