import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

OutlinedButton cancelButton({
  VoidCallback? onClick,
  String text = 'Batal',
  double fontSize = 16,
}) {
  return OutlinedButton(
    onPressed: onClick,
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: outlinedBtnColor,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24
      ),
    ),
    child: Text(
      text,
      style: greyTextStyle.copyWith(
        fontSize: fontSize,
        fontWeight: medium,
      ),
    )
  );
}