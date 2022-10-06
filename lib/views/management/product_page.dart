// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
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
  bool statusFilled = false;
  late ProductProvider productProvider;

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    getInit();
  }

  @override
  void dispose() {
    searchController.clear();
    productProvider.disposeSearch();
    super.dispose();
  }

  getInit() async {
    await Future.wait([
      productProvider.getProducts(),
      productProvider.pusherStock(),
      productProvider.pusherProductStatus(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    print("== build product page from scratch");

    void clearSearch() {
      searchController.clear();
      statusFilled = false;
      context.read<ProductProvider>().searchProduct('');
    }

    Widget btnAddProduct() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
              width: 180,
              child: AddButton(
                  onClick: () {
                    Navigator.pushNamed(context, '/form-add-product');
                    clearSearch();
                  },
                  icon: Icons.add_circle_outlined,
                  text: 'Tambah Produk'
              )
          ),
        ),
      );
    }

    Widget search() {
      return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              style: primaryTextStyle,
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                isCollapsed: true,
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: secondaryTextColor),
                ),
                hintText: 'Cari nama produk',
                hintStyle: secondaryTextStyle.copyWith(fontSize: 14),
                prefixIcon: Icon(Icons.search, color: secondaryTextColor, size: 20,),
                suffixIcon: statusFilled
                    ? InkWell(
                        onTap: () {
                          clearSearch();
                        },
                        child: Icon(Icons.cancel, color: secondaryTextColor, size: 20,))
                    : null,
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: (value) {
                productProvider.searchProduct(value);
                if(value.isNotEmpty) {
                  statusFilled = true;
                } else {
                  statusFilled = false;
                }
              },
            ),
          );
        }
      );
    }

    Widget content() {
      return Column(
        children: [
          btnAddProduct(),
          search(),
          SizedBox(height: 20,),
          Flexible(
              child: Consumer<ProductProvider>(
                builder: (context, data, child) {
                  return SizedBox(
                      child: data.loading ?
                      Center(
                        child: CircularProgressIndicator(),
                      )
                      :
                      data.products.isEmpty
                      ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
                            Image.asset('assets/empty-icon.png', width: MediaQuery.of(context).size.width - (10 * defaultMargin),),
                            Text(
                              'Mohon maaf, produk tidak ditemukan',
                              style: primaryTextStyle.copyWith(
                                  fontWeight: medium,
                                  fontSize: 18),
                            )
                          ],
                        ),
                      )
                      : ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.products.length,
                        itemBuilder: (context, index) {
                          ProductModel product = data.products[index];
                          return ProductCard(product: product);
                        },
                      )
                  );
                },
              )
          ),
        ],
      );
    }

    Future<void> refreshData() async{
      productProvider.products = [];

      //search field dikosongkan spy data utuh
      searchController.clear();
      productProvider.disposeSearch();

      await productProvider.getProducts();
    }

    return RefreshIndicator(
      onRefresh: refreshData,
      child: Scaffold(
        appBar: customAppBar(
            text: 'Daftar Produk'
        ),
        body: content(),
      ),
    );
  }
}
