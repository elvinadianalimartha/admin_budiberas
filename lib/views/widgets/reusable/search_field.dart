import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final TextEditingController searchController;
  final VoidCallback resetField;
  final VoidCallback chooseDate;

  const SearchField({
    Key? key,
    required this.hintText,
    required this.searchController,
    required this.resetField,
    required this.chooseDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: secondaryTextColor.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                style: primaryTextStyle,
                controller: searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration.collapsed(
                    enabled: false,
                    hintText: hintText,
                    hintStyle: secondaryTextStyle
                ),
              ),
            ),
            Row(
              children: [
                searchController.text.isNotEmpty
                    ? TextButton(
                  onPressed: resetField,
                  child: Text(
                    'Reset',
                    style: priceTextStyle.copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                    : const SizedBox(),
                const SizedBox(width: 20,),
                GestureDetector(
                    onTap: chooseDate,
                    child: Icon(
                      Icons.calendar_today_outlined,
                      color: secondaryTextColor,
                      size: 24,)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
