// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import '../../../theme.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (){},
        style: TextButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Menyimpan',
              style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium
              ),
            ),
            SizedBox(width: 8,),
            Container(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  Colors.white,
                ),
              ),
            ),
          ],
        )
      );
  }
}
