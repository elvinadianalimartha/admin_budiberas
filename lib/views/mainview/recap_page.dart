import 'package:budiberas_admin_9701/models/report_daily_model.dart';
import 'package:budiberas_admin_9701/models/report_soldout_model.dart';
import 'package:budiberas_admin_9701/providers/report_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/image_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportOptions extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ReportOptions({
    Key? key,
    required this.text,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: secondaryTextColor.withOpacity(0.35),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: primaryTextStyle,
            ),
            Icon(Icons.chevron_right, color: outlinedBtnColor,)
          ],
        ),
      ),
    );
  }
}

class ClickForBriefOrCompleteData extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ClickForBriefOrCompleteData({
    Key? key,
    required this.onTap,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: blueTextStyle.copyWith(fontWeight: semiBold, decoration: TextDecoration.underline),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}

class RecapPage extends StatefulWidget {
  const RecapPage({Key? key}) : super(key: key);

  @override
  _RecapPageState createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  bool fullReportSoldOut = false;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Future.wait([
      Provider.of<ReportProvider>(context, listen: false).getCountNewOrder(),
      Provider.of<ReportProvider>(context, listen: false).reportDailySales(),
      Provider.of<ReportProvider>(context, listen: false).reportSoldOut(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPattern('id');
    
    Widget activitySummary() {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Aktivitas Toko Hari Ini',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 8,),
            Consumer<ReportProvider>(
              builder: (context, reportProv, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: secondaryTextColor.withOpacity(0.5)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Pesanan Baru',
                        style: priceTextStyle.copyWith(fontWeight: semiBold),
                      ),
                      const SizedBox(height: 5,),
                      Text(
                        reportProv.countNewOrder.toString(),
                        style: primaryTextStyle.copyWith(fontWeight: semiBold),
                      ),
                    ],
                  )
                );
              }
            )
          ],
        ),
      );
    }

    Widget miaw(ReportProvider reportProv, int length) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: length,
          itemBuilder: (context, index) {
            ReportSoldOutModel soldOut = reportProv.soldOut[index];
            return Column(
              children: [
                Row(
                  children: [
                    soldOut.photoUrl == null
                        ? ClipRRect(
                      child: ImageBuilderWidgets().blankImage(sizeIcon: 50),
                      borderRadius: BorderRadius.circular(4),
                    )
                        : ClipRRect(
                      child: ImageBuilderWidgets().imageFromNetwork(
                          imageUrl: soldOut.photoUrl!,
                          width: 50,
                          height: 50,
                          sizeIconError: 50
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(width: 16,),
                    Flexible(
                      child: Text(
                        soldOut.productName,
                        style: primaryTextStyle,
                      ),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(thickness: 1,),
                ),
              ],
            );
          }
      );
    }

    Widget soldOut() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stok Habis',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 8),
              child: Text(
                'Segera tambahkan stoknya',
                style: secondaryTextStyle,
              ),
            ),
            fullReportSoldOut == false
              ? Consumer<ReportProvider>(
                builder: (context, reportProv, child) {
                  return miaw(reportProv, 2);
                }
              ) : Consumer<ReportProvider>(
                  builder: (context, reportProv, child) {
                    return miaw(reportProv, reportProv.soldOut.length);
                  }
                ),
            fullReportSoldOut == false
              ? ClickForBriefOrCompleteData(
                  text: 'Lihat selengkapnya',
                  onTap: () {
                    setState(() {
                      fullReportSoldOut = true;
                    });
                  }
                )
              : ClickForBriefOrCompleteData(
                  text: 'Ringkas kembali',
                  onTap: () {
                    setState(() {
                      fullReportSoldOut = false;
                    });
                  }
                )
          ],
        ),
      );
    }

    final dailySalesColumns = ['Produk', 'Jumlah', 'Subtotal'];
    List<DataColumn> getDailyColumns(List<String> columns) {
      return columns.map(
        (String columnName) => DataColumn(
          label: Text(columnName, style: primaryTextStyle.copyWith(fontWeight: semiBold),),
        )
      ).toList();
    }

    List<DataRow> getDailyRows(List<ReportDailyModel> dailySalesDetails)
        => dailySalesDetails.map((ReportDailyModel dailySales) {
          final cells = [dailySales.productName, dailySales.qtySold, 'Rp ${formatter.format(dailySales.totalSold)}'];
          return DataRow(cells: [
              DataCell(
                SizedBox(
                  width: 100,
                  child: Text('${cells[0]}', style: primaryTextStyle,)
                )
              ),
              DataCell(
                Text('${cells[1]}', style: primaryTextStyle,)
              ),
              DataCell(
                Text('${cells[2]}', style: primaryTextStyle,)
              )
          ]);
        }).toList();

    Widget dailySales() {
      return Consumer<ReportProvider>(
        builder: (context, reportProv, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laporan Penjualan Harian',
                  style: primaryTextStyle.copyWith(fontWeight: semiBold),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: fourthColor.withOpacity(0.4),
                  child: Text(
                    'Total omzet: Rp ${formatter.format(reportProv.dailyOmzet)}',
                    style: priceTextStyle.copyWith(fontWeight: semiBold),
                  ),
                ),
                reportProv.dailyOmzet == 0
                ? const SizedBox()
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: getDailyColumns(dailySalesColumns),
                    rows: getDailyRows(reportProv.dailySalesDetail)
                  ),
                )
              ],
            ),
          );
        }
      );
    }

    Widget otherReport() {
      return Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lihat Laporan Lainnya',
              style: primaryTextStyle.copyWith(fontWeight: semiBold),
            ),
            const SizedBox(height: 12,),
            ReportOptions(
                text: 'Laporan Penjualan Bulanan',
                onTap: () {
                  Navigator.pushNamed(context, '/monthly-report');
                }
            ),
            const SizedBox(height: 20,),
            ReportOptions(
                text: 'Laporan Penjualan Tahunan',
                onTap: () {
                  Navigator.pushNamed(context, '/annual-report');
                }
            ),
            const SizedBox(height: 20,),
            ReportOptions(
                text: 'Laporan Sisa Stok',
                onTap: () {
                  Navigator.pushNamed(context, '/remaining-stock-report');
                }
            )
          ],
        ),
      );
    }

    Widget content() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          activitySummary(),
          soldOut(),
          const Divider(thickness: 2,),
          dailySales(),
          const Divider(thickness: 2,),
          otherReport(),
        ],
      );
    }

    return Scaffold(
      appBar: customAppBar(text: 'Rekap Penjualan Toko'),
      body: Consumer<ReportProvider>(
        builder: (context, reportProv, child) {
          return Center(
            child: SingleChildScrollView(
              child: reportProv.loadingDaily || reportProv.loadingSoldOut
                ? const CircularProgressIndicator()
                : content(),
            ),
          );
        }
      ),
    );
  }
}
