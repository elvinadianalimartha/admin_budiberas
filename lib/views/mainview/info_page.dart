import 'package:budiberas_admin_9701/providers/auth_provider.dart';
import 'package:budiberas_admin_9701/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/reusable/alert_dialog.dart';
import '../widgets/reusable/cancel_button.dart';
import '../widgets/reusable/done_button.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Widget settingOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pengaturan Akun',
              style: primaryTextStyle,
            ),
            Icon(Icons.chevron_right, color: secondaryTextColor,)
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informasi Toko',
                style: primaryTextStyle,
              ),
              Icon(Icons.chevron_right, color: secondaryTextColor,)
            ],
          ),
        ),
        InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/shipping-rate-page');
            },
            child: Ink(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biaya Pengantaran',
                      style: primaryTextStyle,
                    ),
                    Icon(Icons.chevron_right, color: secondaryTextColor,)
                  ],
                ),
              ),
            )
        ),
      ],
    );
  }

  handleLogout() async{
    if(await context.read<AuthProvider>().logout()) {
      SharedPreferences loginData = await SharedPreferences.getInstance();
      loginData.remove('tokenAdmin'); //tokenAdmin diset jd null
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Gagal logout',
            ),
            backgroundColor: alertColor,
            duration: const Duration(milliseconds: 700),
          )
      );
    }
  }

  Future<void> showDialogAreYouSure() async{
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialogWidget(
          text: 'Apakah Anda yakin ingin keluar dari aplikasi?',
          childrenList: [
            CancelButton(
              onClick: () {
                Navigator.pop(context);
              },
              text: 'Tidak',
              fontSize: 14,
            ),
            DoneButton(
              onClick: () {
                handleLogout();
              },
              text: 'Ya, keluar',
              fontSize: 14,
            ),
          ],
        )
    );
  }

  Widget logout() {
    return GestureDetector(
      onTap: () {
        showDialogAreYouSure();
      },
      child: Row(
        children: [
          Icon(Icons.logout, color: alertColor,),
          const SizedBox(width: 8,),
          Text(
            'Keluar',
            style: primaryTextStyle,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: primaryColor,
        toolbarHeight: 65,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/small_logo.png', width: 40,),
              const SizedBox(width: 20,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Toko Sembako Budi Beras',
                      style: whiteTextStyle.copyWith(
                        fontWeight: semiBold,
                        fontSize: 15,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          settingOption(),
          const Divider(thickness: 2,),
          const SizedBox(height: 12,),
          logout(),
        ],
      ),
    );
  }
}
