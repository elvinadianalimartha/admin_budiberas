// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/providers/category_provider.dart';
import 'package:budiberas_admin_9701/providers/gallery_provider.dart';
import 'package:budiberas_admin_9701/providers/incoming_stock_provider.dart';
import 'package:budiberas_admin_9701/providers/out_stock_provider.dart';
import 'package:budiberas_admin_9701/providers/page_provider.dart';
import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/providers/report_provider.dart';
import 'package:budiberas_admin_9701/providers/shifting_stock_provider.dart';
import 'package:budiberas_admin_9701/providers/transaction_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:budiberas_admin_9701/views/form/add_product.dart';
import 'package:budiberas_admin_9701/views/form/shifting_stock.dart';
import 'package:budiberas_admin_9701/views/mainview/main_page.dart';
import 'package:budiberas_admin_9701/views/management/category_page.dart';
import 'package:budiberas_admin_9701/views/management/incoming_stock_page.dart';
import 'package:budiberas_admin_9701/views/management/product_page.dart';
import 'package:budiberas_admin_9701/views/management/return_to_supplier_page.dart';
import 'package:budiberas_admin_9701/views/management/shift_stock_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageProvider(),),
        ChangeNotifierProvider(create: (context) => CategoryProvider(),),
        ChangeNotifierProvider(create: (context) => ProductProvider(),),
        ChangeNotifierProvider(create: (context) => GalleryProvider(),),
        ChangeNotifierProvider(create: (context) => IncomingStockProvider(),),
        ChangeNotifierProvider(create: (context) => OutStockProvider(),),
        ChangeNotifierProvider(create: (context) => ShiftingStockProvider(),),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
        ChangeNotifierProvider(create: (context) => ReportProvider()),
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('id', ''), // Indonesia, no country code
        ],
        routes: {
          '/': (context) => MainPage(),
          '/manage-category': (context) => ManageCategoryPage(),
          '/manage-product': (context) => ProductPage(),
          '/form-add-product': (context) => FormAddProduct(),
          '/manage-incoming-stock': (context) => IncomingStock(),
          '/manage-return-to-supplier': (context) => ReturnToSupplierPage(),
          '/manage-shifting-stock': (context) => ShiftingStockPage(),
          '/form-shifting-stock': (context) => FormShiftingStock(),
        },
      ),
    );
  }
}
