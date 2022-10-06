import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/text_field.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../providers/category_provider.dart';
import '../../theme.dart';
import '../widgets/reusable/done_button.dart';

class FormEditDataProduct extends StatefulWidget {
  final ProductModel product;

  const FormEditDataProduct({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  _FormEditDataProductState createState() => _FormEditDataProductState();
}

class _FormEditDataProductState extends State<FormEditDataProduct> {

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Future.wait([
      Provider.of<CategoryProvider>(context, listen: false).getCategories(),
      Provider.of<ProductProvider>(context, listen: false).checkProductInTransaction(id: widget.product.id),
    ]);
    Provider.of<ProductProvider>(context, listen: false).setDefaultCanBeRetailed(widget.product.canBeRetailed);
  }

  @override
  Widget build(BuildContext context) {
    print('=== build from scratch ===');

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController productNameController = TextEditingController(text: widget.product.name);

    var size = widget.product.size;
    var formattedSize;
    var decimalNumber = size % 1; //get decimal value (angka di belakang koma)
    if(decimalNumber == 0) {
      formattedSize = size.toInt();
    } else {
      formattedSize = size;
    }
    TextEditingController sizeController = TextEditingController(text: formattedSize.toString());

    int price = widget.product.price.toInt();
    TextEditingController priceController = TextEditingController(text: price.toString());
    TextEditingController descriptionController = TextEditingController(text: widget.product.description);

    Object? _value;
    int _intValue = widget.product.category.id;

    handleEditData(ProductProvider productProvider) async {
      print('categoryId: $_intValue');
      print('id: ${widget.product.id}');

      if(await productProvider.updateProduct(
        id: widget.product.id,
        categoryId: _intValue,
        productName: productNameController.text,
        size: double.parse(sizeController.text),
        price: double.parse(priceController.text),
        description: descriptionController.text,
        canBeRetailed: productProvider.selectedValue,
      )) {
        Navigator.popUntil(context, ModalRoute.withName('/manage-product'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data berhasil diperbarui'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data gagal diperbarui'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Widget chooseCategory() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 8,),
          Consumer<CategoryProvider>(
            builder: (context, data, child) {
              List<CategoryModel> listCategories = data.categories;
              return DropdownButtonFormField2(
                  decoration: InputDecoration(
                    isCollapsed: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: formColor,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  value: widget.product.category.id,
                  hint: Text('Pilih kategory produk', style: secondaryTextStyle,),
                  items: listCategories.map((item) {
                    return DropdownMenuItem<Object>(
                      child: Text(item.category_name, style: primaryTextStyle.copyWith(fontSize: 14),),
                      value: item.id,
                    );
                  }).toList(),
                  onChanged: (value) {
                    _value = value;
                    _intValue = _value as int;
                    print(_intValue);
                  }
              );
            },
          )
        ],
      );
    }

    Widget productName() {
      return Column(
        mainAxisSize: MainAxisSize.min,
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
          Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return TextFormFieldWidget(
                  readOnly: productProvider.productInTransaction == 0 ? false : true,
                  hintText: 'Masukkan nama produk',
                  controller: productNameController,
                  actionKeyboard: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama produk harus diisi';
                    } else if(productProvider.editCheckIfUsed(widget.product.id, value)) {
                      return 'Nama produk sudah pernah digunakan';
                    }
                    return null;
                  },
                );
              }
          ),
        ],
      );
    }

    Widget productSize() {
      return Column(
        mainAxisSize: MainAxisSize.min,
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
            //inputFormatter: [FilteringTextInputFormatter.digitsOnly],
            actionKeyboard: TextInputAction.done,
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

    Widget chooseRetailed() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bisa diecer?',
            style: primaryTextStyle.copyWith(
              fontWeight: medium,
            ),
          ),
          Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                print(productProvider.selectedValue);
                return Row(
                  children: [
                    Flexible(
                      child: RadioListTile<int>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        value: 1,
                        groupValue: productProvider.selectedValue,
                        onChanged: (value) {
                          productProvider.changeRetailedValue(value!);
                        },
                        title: Text('Ya', style: primaryTextStyle.copyWith(fontSize: 14),),
                        activeColor: priceColor,
                      ),
                    ),
                    Flexible(
                      child: RadioListTile<int>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                        value: 0,
                        groupValue: productProvider.selectedValue,
                        onChanged: (value) {
                          productProvider.changeRetailedValue(value!);
                        },
                        title: Text('Tidak', style: primaryTextStyle.copyWith(fontSize: 14)),
                        activeColor: priceColor,
                      ),
                    ),
                  ],
                );
              }
          ),
        ],
      );
    }

    Widget productPrice() {
      return Column(
        mainAxisSize: MainAxisSize.min,
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
            actionKeyboard: TextInputAction.done,
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
        mainAxisSize: MainAxisSize.min,
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
      return Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            return SizedBox(
              height: 50,
              width: double.infinity, //supaya selebar layar
              child: //productProvider.loading
              //? const LoadingButton()
              //:
              DoneButton(
                text: 'Simpan',
                onClick: () {
                  if(_formKey.currentState!.validate()) {
                    handleEditData(productProvider);
                  }
                },
              ),
            );
          }
      );
    }

    Widget content() {
      return Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                chooseCategory(),
                const SizedBox(height: 20,),
                productName(),
                const SizedBox(height: 20,),
                productSize(),
                const SizedBox(height: 20,),
                chooseRetailed(),
                const SizedBox(height: 20,),
                productPrice(),
                const SizedBox(height: 20,),
                productDescription(),
                const SizedBox(height: 36,),
                saveButton(),
              ]
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () {
        context.read<ProductProvider>().selectedValue = (widget.product.canBeRetailed);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: customAppBar(text: 'Form Ubah Data Produk'),
        body: content(),
      ),
    );
  }
}