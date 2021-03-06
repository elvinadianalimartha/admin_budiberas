import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class AddButton extends StatelessWidget {
  final VoidCallback? onClick;
  final String text;
  final IconData? icon;

  const AddButton({
    Key? key,
    this.onClick,
    required this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClick,
      style: TextButton.styleFrom(
        backgroundColor: priceColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: btnManageColor,),
          const SizedBox(width: 11,),
          Flexible(
            child: Text(
              text,
              style: whiteTextStyle.copyWith(
                fontWeight: medium,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}