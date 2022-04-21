import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class TextField extends StatelessWidget {
  const TextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full Name',
              style: primaryTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                  horizontal: 16
              ),
              decoration: BoxDecoration(
                  //color: backgroundColor2,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(Icons.person, color: primaryColor),
                    SizedBox(width: 16,),
                    Expanded( //expanded supaya dia lebarnya selebar ruang yg tersisa
                      child: TextFormField(
                        style: primaryTextStyle,
                        //controller: nameController,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Your full name',
                            //hintStyle: subtitleTextStyle
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
  }
}
