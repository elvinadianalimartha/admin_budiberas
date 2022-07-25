// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/providers/page_provider.dart';
import 'package:budiberas_admin_9701/views/mainview/info_page.dart';
import 'package:budiberas_admin_9701/views/mainview/management_page.dart';
import 'package:budiberas_admin_9701/views/mainview/order_page.dart';
import 'package:budiberas_admin_9701/views/mainview/recap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import 'chat_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    PageProvider pageProvider = Provider.of<PageProvider>(context);

    Widget customBottomNav() {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Color(0xff2895BD).withOpacity(0.3), blurRadius: 20.0)
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: pageProvider.currentIndex,
            onTap: (value) {
              print(value);
              pageProvider.currentIndex = value;
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Image.asset(
                    'assets/recap_icon.png',
                    width: 20,
                    color: pageProvider.currentIndex == 0 ? secondaryColor : Color(0xff999999),
                  ),
                ),
                label: 'Rekap'
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Image.asset(
                    'assets/order_icon.png',
                    width: 20,
                    color: pageProvider.currentIndex == 1 ? secondaryColor : Color(0xff999999),
                  ),
                ),
                label: 'Pesanan'
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Image.asset(
                    'assets/management_icon.png',
                    width: 20,
                    color: pageProvider.currentIndex == 2 ? secondaryColor : Color(0xff999999),
                  ),
                ),
                label: 'Kelola'
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 14, bottom: 5),
                  child: Image.asset(
                    'assets/chat_icon.png',
                    width: 20,
                    color: pageProvider.currentIndex == 3 ? secondaryColor : Color(0xff999999),
                  ),
                ),
                label: 'Obrolan'
              ),
              BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Image.asset(
                    'assets/info_icon.png',
                    width: 20,
                    color: pageProvider.currentIndex == 4 ? secondaryColor : Color(0xff999999),
                  ),
                ),
                label: 'Info Toko'
              ),
            ],
            selectedItemColor: secondaryColor,
            selectedFontSize: 14,
            unselectedFontSize: 12,
            selectedLabelStyle: labelTextStyle,
            unselectedLabelStyle: secondaryTextStyle,
          ),
        ),
      );
    }

    Widget body() {
      switch(pageProvider.currentIndex) {
        case 0:
          return RecapPage();
        case 1:
          return OrderPage();
        case 2:
          return ManagementPage();
        case 3:
          return ChatPage();
        case 4:
          return InfoPage();
        default:
          return RecapPage();
      }
    }

    return Scaffold(
      bottomNavigationBar: customBottomNav(),
      body: body(),
    );
  }
}
