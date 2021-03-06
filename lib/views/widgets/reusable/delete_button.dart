import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class DeleteButton extends StatelessWidget {
  final VoidCallback? onClick;

  const DeleteButton({
    Key? key,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onClick,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: alertColor,
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        padding: const EdgeInsets.all(8),
      ),
      child: Row(
        children: [
          //Icon(Icons.delete, color: alertColor, size: 22,),
          Image.asset('assets/delete_icon.png', width: 16,),
          const SizedBox(width: 9,),
          Text(
            'Hapus',
            style: alertTextStyle.copyWith(
              fontWeight: medium,
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}