import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({Key? key}) : super(key: key);

  @override
  _FormAddProductState createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  @override
  Widget build(BuildContext context) {
    //panggil dari widget text_field

    // Widget signUpButton(){
    //   return Container(
    //     height: 50,
    //     width: double.infinity, //supaya selebar layar
    //     margin: EdgeInsets.only(top: 30),
    //     child: TextButton(
    //         onPressed: handleSignUp,
    //         style: TextButton.styleFrom(
    //             backgroundColor: primaryColor,
    //             shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(12)
    //             )
    //         ),
    //         child: Text(
    //           'Sign Up',
    //           style: primaryTextStyle.copyWith(
    //               fontSize: 16,
    //               fontWeight: medium
    //           ),
    //         )
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Form Tambah Produk',
          style: whiteTextStyle.copyWith(
            fontWeight: semiBold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
