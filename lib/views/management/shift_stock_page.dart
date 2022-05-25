import 'package:budiberas_admin_9701/models/shift_stock_model.dart';
import 'package:budiberas_admin_9701/providers/shifting_stock_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/add_button.dart';
import 'package:budiberas_admin_9701/views/widgets/shift_stock_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import '../widgets/reusable/app_bar.dart';
import '../widgets/reusable/search_field.dart';

class ShiftingStockPage extends StatefulWidget {
  const ShiftingStockPage({Key? key}) : super(key: key);

  @override
  _ShiftingStockPageState createState() => _ShiftingStockPageState();
}

class _ShiftingStockPageState extends State<ShiftingStockPage> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  void initState() {
    getInit();
    super.initState();
  }

  void getInit() async {
    await Provider.of<ShiftingStockProvider>(context, listen: false).getShiftStocks();
  }

  @override
  Widget build(BuildContext context) {
    Widget btnShiftingStock() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: 150,
            child: AddButton(
              onClick: () {
                Navigator.pushNamed(context, '/form-shifting-stock');
              },
              text: 'Alihkan Stok',
              icon: Icons.add_circle_outlined,
            ),
          ),
        ),
      );
    }

    Widget search(){
      return Consumer<ShiftingStockProvider>(
        builder: (context, data, child){
          return SearchField(
            hintText: 'Cari histori per tanggal',
            searchController: searchController,
            resetField: () {
              searchController.clear();
              data.searchShiftStockByDate(null);
            },
            chooseDate: () async{
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
              data.searchShiftStockByDate(chosenDate);
            }
          );
        }
      );
    }

    Widget content() {
      return Column(
        children: [
          btnShiftingStock(),
          search(),
          const SizedBox(height: 20,),
          Flexible(
            child: Consumer<ShiftingStockProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                    child: data.loading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        :
                    data.shiftStocks.isEmpty
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
                        itemCount: data.shiftStocks.length,
                        itemBuilder: (context, index) {
                          ShiftStockModel shiftStocks = data.shiftStocks[index];
                          return ShiftStockCard(shiftStocks: shiftStocks,);
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
        context.read<ShiftingStockProvider>().searchShiftStockByDate(null);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: customAppBar(
            text: 'Pengalihan Stok'
        ),
        body: content(),
      ),
    );
  }
}
