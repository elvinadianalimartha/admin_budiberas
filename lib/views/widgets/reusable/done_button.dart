import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

TextButton doneButton({
  VoidCallback? onClick,
  required String text,
  double fontSize = 16,
}) {
  return TextButton(
    onPressed: onClick,
    style: TextButton.styleFrom(
      backgroundColor: btnColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
      ),
      //padding: const EdgeInsets.all(8),
    ),
    child: Text(
      text,
      style: whiteTextStyle.copyWith(
        fontSize: fontSize,
        fontWeight: medium,
      ),
    )
  );
}