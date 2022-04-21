// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/views/widgets/management_option_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ManagementPage extends StatefulWidget {
  const ManagementPage({Key? key}) : super(key: key);

  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  @override
  Widget build(BuildContext context) {
    Widget content() {
      return ListView(
        padding: EdgeInsets.all(defaultMargin),
        children: [
          Text(
              'Produk yang Dijual',
              style: secondaryTextStyle.copyWith(
                fontWeight: medium,
              )
          ),
          GestureDetector(
            child: ManagementOptionCard('Kategori Produk'),
            onTap: () {
              Navigator.pushNamed(context, '/manage-category');
            }
          ),
          SizedBox(height: 5,),
          GestureDetector(
            child: ManagementOptionCard('Produk'),
            onTap: () {
              Navigator.pushNamed(context, '/manage-product');
            },
          ),

          SizedBox(height: 30,),

          Text(
              'Stok Produk',
              style: secondaryTextStyle.copyWith(
                fontWeight: medium,
              )
          ),
          ManagementOptionCard('Stok Masuk'),
          SizedBox(height: 5,),
          ManagementOptionCard('Stok Keluar: Penjualan Offline'),
          SizedBox(height: 5,),
          ManagementOptionCard('Stok Keluar: Retur ke Supplier'),
          SizedBox(height: 5,),
          ManagementOptionCard('Pengalihan Stok'),

          SizedBox(height: 30,),

          Text(
              'Filter',
              style: secondaryTextStyle.copyWith(
                fontWeight: medium,
              )
          ),
          ManagementOptionCard('Kriteria Filter'),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Kelola Produk, Stok, Filter',
          style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 16,
          ),
        ),
      ),
      body: content(),
    );
  }
}
