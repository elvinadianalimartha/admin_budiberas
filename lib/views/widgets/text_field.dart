import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme.dart';

class TextFormFieldWidget extends StatefulWidget {
  final TextInputType? textInputType; //numeric or usual
  final List<TextInputFormatter>? inputFormatter; //format for input (lowercase, using regex, etc)
  final String hintText;
  final Widget? prefixIcon;
  final Widget? prefix; //prefix like Rp
  final FocusNode? focusNode;
  final bool obscureText;
  final TextEditingController? controller;
  final Function? functionValidate;
  final String? parametersValidate;
  final TextInputAction? actionKeyboard; //done, search, next, etc.
  final FormFieldValidator<String>? validator;

  const TextFormFieldWidget({
    Key? key,
    this.textInputType,
    this.inputFormatter,
    required this.hintText,
    this.prefixIcon,
    this.prefix,
    this.focusNode,
    this.obscureText = false,
    this.controller,
    this.functionValidate,
    this.parametersValidate,
    this.actionKeyboard = TextInputAction.next,
    this.validator,
  }) : super(key: key);

  @override
  _TextFormFieldWidgetState createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
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
        isCollapsed: true,
        border: InputBorder.none,
        prefixIcon: widget.prefixIcon,
        prefix: widget.prefix,
        hintText: widget.hintText,
        hintStyle: secondaryTextStyle,
      ),
      controller: widget.controller,
      validator: widget.validator,
      // validator: (value) {
      //   if(widget.functionValidate != null) {
      //     widget.functionValidate!(value, widget.parametersValidate);
      //   }
      //   return null;
      // },
    );
  }
}
