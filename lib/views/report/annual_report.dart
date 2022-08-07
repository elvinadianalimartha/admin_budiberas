import 'package:budiberas_admin_9701/models/report_annual_model.dart';
import 'package:budiberas_admin_9701/providers/report_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnnualReportPage extends StatefulWidget {
  const AnnualReportPage({Key? key}) : super(key: key);

  @override
  State<AnnualReportPage> createState() => _AnnualReportPageState();
}

class _AnnualReportPageState extends State<AnnualReportPage> {
  var currentYear = '';

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async{
    currentYear = DateTime.now().year.toString();
    await Provider.of<ReportProvider>(context, listen: false).reportAnnualSales(chosenYear: currentYear);
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    ReportProvider reportProv = Provider.of<ReportProvider>(context);
    TextEditingController inputYear = TextEditingController(text: currentYear);

    Widget chooseYear() {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Tahun Laporan : ',
            style: primaryTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(width: 8,),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: inputYear,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4),],
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: outlinedBtnColor),
                ),
                contentPadding: const EdgeInsets.all(8)
              ),
              onFieldSubmitted: (value) {
                setState(() {
                  currentYear = value;
                });
                reportProv.reportAnnualSales(chosenYear: currentYear);
              },
            ),
          ),
        ],
      );
    }

    List<DataColumn> getAnnualColumns() {
      return [
        DataColumn(
          label: Text('Bulan', style: primaryTextStyle.copyWith(fontWeight: semiBold),)
        ),
        DataColumn(
            label: Text('Omzet', style: primaryTextStyle.copyWith(fontWeight: semiBold),)
        ),
        DataColumn(
          label: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Pajak ',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold)
                ),
                TextSpan(
                  text: '(omzet x 0,5%)',
                  style: secondaryTextStyle.copyWith(fontWeight: semiBold)
                )
              ]
            ),
          )
        )
      ];
    }

    List<DataCell> getCells(List<dynamic> cells) => cells.map(
      (data) => DataCell(
        Text(data, style: primaryTextStyle,),
    )).toList();

    List<DataRow> getAnnualRows(List<ReportAnnualModel> annualSales)
      => annualSales.map((ReportAnnualModel sale) {
        final cells = [
          sale.month,
          'Rp ${formatter.format(sale.omzet)}',
          'Rp ${formatter.format(sale.tax)}'
        ];
        return DataRow(cells: getCells(cells));
      }).toList();

    Widget totalOmzet() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: fourthColor.withOpacity(0.4),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          'Total omzet: Rp ${formatter.format(reportProv.totalAnnualOmzet)}',
          style: priceTextStyle.copyWith(fontWeight: semiBold),
        ),
      );
    }

    Widget totalTax() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.blueAccent.withOpacity(0.25),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          'Pajak yang harus dibayar: Rp ${formatter.format(reportProv.totalTax)}',
          style: blueTextStyle.copyWith(fontWeight: semiBold),
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

    Widget contentTable() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: getAnnualColumns(),
          rows: getAnnualRows(reportProv.annualSales),
        ),
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Laporan Penjualan Tahunan'),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chooseYear(),
                const SizedBox(height: 20,),
                totalOmzet(),
                const SizedBox(height: 2,),
                totalTax(),
                const SizedBox(height: 4,),
                reportProv.loadingAnnual
                    ? loadingWidget()
                    : contentTable()
              ],
            ),
          )
      ),
    );
  }
}
