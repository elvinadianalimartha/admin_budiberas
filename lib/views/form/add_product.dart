import 'package:budiberas_admin_9701/views/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({Key? key}) : super(key: key);

  @override
  _FormAddProductState createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController(text: '');
  TextEditingController sizeController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Widget productName() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nama produk',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
                horizontal: 16
            ),
            decoration: BoxDecoration(
                color: formColor,
                borderRadius: BorderRadius.circular(12)
            ),
            child: Center(
              child: TextFormFieldWidget(
                hintText: 'Masukkan nama produk',
                controller: productNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama produk harus diisi';
                  }
                  return null;
                },
              ),
            ),
          )
        ],
      );
    }

    Widget productSize() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ukuran produk (kg/L)',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
                horizontal: 16
            ),
            decoration: BoxDecoration(
                color: formColor,
                borderRadius: BorderRadius.circular(12)
            ),
            child: Center(
              child: TextFormFieldWidget(
                hintText: 'Masukkan ukuran produk',
                controller: sizeController,
                textInputType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ukuran harus diisi';
                  }
                  return null;
                },
              ),
            ),
          )
        ],
      );
    }

    Widget saveButton(){
      return Container(
        height: 50,
        width: double.infinity, //supaya selebar layar
        margin: EdgeInsets.only(top: 30),
        child: TextButton(
            onPressed: () {
              if(_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil tersimpan')),
                );
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: btnColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                )
            ),
            child: Text(
              'Simpan',
              style: whiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: medium
              ),
            )
        ),
      );
    }

    Widget content() {
      return Form(
        key: _formKey,
        child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              productName(),
              const SizedBox(height: 16,),
              productSize(),
              const SizedBox(height: 24,),
              saveButton(),
            ]
        )
      );
    }

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
      body: content(),
    );
  }
}

String? requiredValidator(String? value, String messageError) {
  if (value == null || value.isEmpty) {
    return messageError;
  }
  return null;
}
