// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/views/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../widgets/reusable/add_button.dart';
import '../widgets/reusable/app_bar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  TextEditingController searchController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget btnAddProduct() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            width: 170,
            child: addButton(
              onClick: () {
                Navigator.pushNamed(context, '/form-add-product');
              },
              icon: Icons.add_circle_outlined,
              text: 'Tambah Produk'
            )
          ),
        ),
      );
    }

    Widget search() {
      return Container(
        height: 45,
        width: MediaQuery.of(context).size.width - 40,
        padding: EdgeInsets.symmetric(
            horizontal: 16
        ),
        decoration: BoxDecoration(
          border: Border.all(color: secondaryTextColor.withOpacity(0.8), width: 0.5),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: primaryTextStyle,
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Cari nama produk',
                      hintStyle: secondaryTextStyle
                  ),
                ),
              ),
              SizedBox(width: 16,),
              Icon(Icons.search, color: secondaryTextColor,),
            ]
        ),
      );
    }

    Widget content() {
      return Column(
        children: [
          btnAddProduct(),
          search(),
          SizedBox(height: 20,),
          Expanded(
            child: ListView(
              //padding: EdgeInsets.all(20),
              shrinkWrap: true,
              children: [
                ProductCard(),
                ProductCard(),
                ProductCard(),
                ProductCard()
              ],
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: customAppBar(
          text: 'Daftar Produk'
      ),
      body: content(),
    );
  }
}
