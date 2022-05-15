import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme.dart';

class LineTextField extends StatefulWidget {
  final TextInputType? textInputType; //numeric or usual
  final List<TextInputFormatter>? inputFormatter; //format for input (lowercase, using regex, etc)
  final String hintText;
  final Widget? prefixIcon;
  final Widget? prefix;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputAction? actionKeyboard; //done, search, next, etc.
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  const LineTextField({
    Key? key,
    this.textInputType,
    this.inputFormatter,
    required this.hintText,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.focusNode,
    this.obscureText = false,
    this.controller,
    this.actionKeyboard = TextInputAction.next,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _LineTextFieldState createState() => _LineTextFieldState();
}

class _LineTextFieldState extends State<LineTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      inputFormatters: widget.inputFormatter,
      textInputAction: widget.actionKeyboard,
      obscureText: widget.obscureText,
      focusNode: widget.focusNode,
      style: primaryTextStyle,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        prefix: widget.prefix,
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        hintStyle: secondaryTextStyle,
      ),
      controller: widget.controller,
      validator: widget.validator,
      maxLines: null,
      readOnly: widget.readOnly,
    );
  }
}
