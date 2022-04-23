import 'package:budiberas_admin_9701/views/widgets/reusable/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme.dart';
import '../widgets/reusable/done_button.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({Key? key}) : super(key: key);

  @override
  _FormAddProductState createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController(text: '');
  TextEditingController sizeController = TextEditingController(text: '');
  TextEditingController priceController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');

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
          Text(
            'Merek produk + ukuran',
            style: secondaryTextStyle.copyWith(
              fontSize: 11
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: 'Masukkan nama produk',
            controller: productNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Nama produk harus diisi';
              }
              return null;
            },
          ),
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
          TextFormFieldWidget(
            hintText: 'Masukkan ukuran produk',
            controller: sizeController,
            textInputType: TextInputType.number,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ukuran harus diisi';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget productPrice() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harga',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: '',
            prefixIcon: Text(
                '\t\t\t\tRp\t\t',
              style: secondaryTextStyle
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            controller: priceController,
            textInputType: TextInputType.number,
            inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Harga produk harus diisi';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget productDescription() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deskripsi produk',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Text(
            'Spesifikasi produk, kelebihannya',
            style: secondaryTextStyle.copyWith(
                fontSize: 11
            ),
          ),
          const SizedBox(height: 8,),
          TextFormFieldWidget(
            hintText: 'Tuliskan deskripsi produk',
            controller: descriptionController,
            textInputType: TextInputType.multiline,
            actionKeyboard: TextInputAction.done,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Deskripsi produk harus diisi';
              }
              return null;
            },
          ),
        ],
      );
    }

    Widget saveButton(){
      return SizedBox(
        height: 50,
        width: double.infinity, //supaya selebar layar
        child: doneButton(
          text: 'Simpan',
          onClick: () {
            if(_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil tersimpan')),
              );
            }
          },
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
              const SizedBox(height: 20,),
              productSize(),
              const SizedBox(height: 20,),
              productPrice(),
              const SizedBox(height: 20,),
              productDescription(),
              const SizedBox(height: 36,),
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