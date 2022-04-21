// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ManagementOptionCard extends StatelessWidget {
  String option;
  ManagementOptionCard(this.option, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: primaryTextStyle.copyWith(
                fontWeight: medium,
              ),
            ),
            Icon(Icons.chevron_right, color: secondaryTextColor,)
          ],
        ),
      ),
    );
  }
}
