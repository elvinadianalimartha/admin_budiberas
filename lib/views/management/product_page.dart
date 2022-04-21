import 'package:budiberas_admin_9701/views/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

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
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/form-add-product');
              },
              style: TextButton.styleFrom(
                backgroundColor: priceColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                ),
                padding: EdgeInsets.all(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.add_circle_outlined, color: btnManageColor,),
                  SizedBox(width: 11,),
                  Text(
                    'Tambah Produk',
                    style: whiteTextStyle.copyWith(
                      fontWeight: medium,
                    ),
                  )
                ],
              ),
            ),
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
          ListView(
            padding: EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              ProductCard()
            ],
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Daftar Produk',
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
