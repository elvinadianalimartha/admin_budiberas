import 'package:flutter/material.dart';

import '../../../theme.dart';

class EditButton extends StatelessWidget {
  final VoidCallback? onClick;
  final String text;
  final IconData? icon;
  final double? iconSize;

  const EditButton({
    Key? key,
    this.onClick,
    this.text = 'Ubah',
    this.icon = Icons.edit,
    this.iconSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              child: Icon(icon, color: Colors.white, size: iconSize),
          ),
          const SizedBox(width: 11,),
          Text(
            text,
            style: yellowTextStyle.copyWith(
              fontWeight: medium,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}