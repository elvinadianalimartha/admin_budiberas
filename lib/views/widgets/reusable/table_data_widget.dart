import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class TableDataWidget extends StatelessWidget {
  final String title;
  final String value;
  final double widthTitleBox;

  const TableDataWidget({
    required this.title,
    required this.value,
    this.widthTitleBox = 120,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widthTitleBox,
          child: Text(
            title,
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(':'),
        ),
        Flexible(
          child: Text(
            value,
            style: primaryTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
