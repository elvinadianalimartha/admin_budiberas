// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/providers/category_provider.dart';
import 'package:budiberas_admin_9701/providers/page_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/form/add_product.dart';
import 'package:budiberas_admin_9701/views/mainview/main_page.dart';
import 'package:budiberas_admin_9701/views/management/category_page.dart';
import 'package:budiberas_admin_9701/views/management/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageProvider(),),
        ChangeNotifierProvider(create: (context) => CategoryProvider(),)
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ThemeData().colorScheme.copyWith(
            primary: secondaryColor,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: secondaryColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => MainPage(),
          '/manage-category': (context) => ManageCategoryPage(),
          '/manage-product': (context) => ProductPage(),
          '/form-add-product': (context) => FormAddProduct(),
        },
      ),
    );
  }
}
