import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

TextButton addButton({
  VoidCallback? onClick,
  required String text,
  required IconData icon,
}) {
  return TextButton(
    onPressed: onClick,
    style: TextButton.styleFrom(
      backgroundColor: priceColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.all(8),
    ),
    child: Row(
      children: [
        Icon(icon, color: btnManageColor,),
        const SizedBox(width: 11,),
        Text(
          text,
          style: whiteTextStyle.copyWith(
            fontWeight: medium,
          ),
        )
      ],
    ),
  );
}