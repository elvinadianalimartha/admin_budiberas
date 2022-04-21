// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({Key? key}) : super(key: key);

  @override
  _ManageCategoryPageState createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  @override
  Widget build(BuildContext context) {

    Widget data() {
      return ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              'Beras',
              style: primaryTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () {
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: btnColor,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: btnColor,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.edit, color: Colors.white, size: 18,)
                      ),
                      SizedBox(width: 11,),
                      Text(
                        'Ubah',
                        style: changeBtnTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20,),
                OutlinedButton(
                  onPressed: () {
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: alertColor,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    padding: EdgeInsets.all(8),
                  ),
                  child: Row(
                    children: [
                      //Icon(Icons.delete, color: alertColor, size: 22,),
                      Image.asset('assets/delete_icon.png', width: 22,),
                      SizedBox(width: 9,),
                      Text(
                        'Hapus',
                        style: alertTextStyle.copyWith(
                          fontWeight: medium,
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              thickness: 1,
            ),
          ),
        ],
      );
    }

    Widget content() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 180,
                child: TextButton(
                  onPressed: () {
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
                        'Tambah Kategori',
                        style: whiteTextStyle.copyWith(
                          fontWeight: medium,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          data(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Kelola Kategori',
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
