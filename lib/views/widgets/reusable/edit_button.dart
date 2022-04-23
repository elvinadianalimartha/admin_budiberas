import 'package:flutter/material.dart';

import '../../../theme.dart';

OutlinedButton editButton({
  VoidCallback? onClick,
  String text = 'Ubah',
}){
  return OutlinedButton(
    onPressed: onClick,
    style: OutlinedButton.styleFrom(
      side: BorderSide(
        color: btnColor,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      padding: const EdgeInsets.all(8),
    ),
    child: Row(
      children: [
        Container(
            decoration: BoxDecoration(
              color: btnColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.edit, color: Colors.white, size: 14
              ,)
        ),
        const SizedBox(width: 11,),
        Text(
          text,
          style: changeBtnTextStyle.copyWith(
            fontWeight: medium,
            fontSize: 12,
          ),
        )
      ],
    ),
  );
}