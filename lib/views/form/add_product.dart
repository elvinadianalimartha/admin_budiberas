import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/add_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../models/gallery_model.dart';
import '../../providers/category_provider.dart';
import '../../providers/gallery_provider.dart';
import '../../theme.dart';
import '../widgets/reusable/done_button.dart';
import 'dart:io' show File, Platform;

import '../widgets/reusable/loading_button.dart';

class FormAddProduct extends StatefulWidget {
  const FormAddProduct({Key? key}) : super(key: key);

  @override
  _FormAddProductState createState() => _FormAddProductState();
}

class _FormAddProductState extends State<FormAddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController(text: '');
  TextEditingController sizeController = TextEditingController(text: '');
  TextEditingController priceController = TextEditingController(text: '');
  TextEditingController descriptionController = TextEditingController(text: '');

  File? image;
  Object? _value;
  int? _intValue;

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<CategoryProvider>(context, listen: false).getCategories();
    Provider.of<GalleryProvider>(context, listen: false).galleries;
    Provider.of<ProductProvider>(context, listen: false).products;
  }

  @override
  Widget build(BuildContext context) {
    print('=== build from scratch ===');

    resetForm() {
      _intValue = null;
      productNameController.clear();
      sizeController.clear();
      priceController.clear();
      descriptionController.clear();
    }

    handleAddData(ProductProvider productProvider, GalleryProvider galleryProvider) async {
      var photoUrl = galleryProvider.galleries.map(
              (e) => File(e.url!)
      ).toList();
      print(photoUrl);

      if(await productProvider.createProduct(
        categoryId: _intValue!,
        name: productNameController.text,
        size: double.parse(sizeController.text),
        price: double.parse(priceController.text),
        description: descriptionController.text,
        canBeRetailed: productProvider.selectedValue,
        productGalleries: photoUrl,
      )) {

        //Reset to starting condition
        resetForm();
        galleryProvider.galleries.clear();
        productProvider.selectedValue = 1;

        //Go to manage product page with newly created product
        productProvider.getProducts();
        Navigator.popUntil(context, ModalRoute.withName('/manage-product'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data berhasil ditambahkan'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data gagal ditambahkan'),
            backgroundColor: alertColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Future<ImageSource?> choosePhotoSource(context) async {
      if(Platform.isIOS) {
        return showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text('Camera', style: primaryTextStyle,),
                  onPressed: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                CupertinoActionSheetAction(
                  child: Text('Gallery', style: primaryTextStyle,),
                  onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
                )
              ],
            )
        );
      } else {
        return showModalBottomSheet(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text('Camera', style: primaryTextStyle,),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: Text('Gallery', style: primaryTextStyle,),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            )
        );
      }
    }

    Future getPicture(ImageSource source, GalleryProvider galleryProvider) async {
      try{
        final imgPicked = await ImagePicker().pickImage(source: source);
        if(imgPicked == null) return;

        galleryProvider.addPhotoTemp(imgPicked.path);
        // image = imageTemp;
      }on PlatformException catch (e) {
        print('Gagal mengambil foto: $e');
      }
    }

    Widget samplePhoto() {
      return SizedBox(
        height: 100,
        child: Consumer<GalleryProvider>(
            builder: (context, galleryProvider, child){
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(width: 8,);
                },
                itemCount: galleryProvider.galleries.length,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  GalleryModel image = galleryProvider.galleries[index];
                  return Stack(
                    children: [
                      image.url != null
                          ? Image.file(File(image.url ?? ''), width: 100,)
                          : Icon(Icons.image, color: secondaryTextColor, size: 60,),
                      Positioned(
                        top: 0,
                        right: 12,
                        child: InkWell(
                            onTap: () {
                              galleryProvider.removePhotoTemp(image.tempId);
                            },
                            child: Image.asset('assets/cancel_icon.png', width: 24,)
                        ),
                      ),
                    ],
                  );
                },
              );
            }
        ),
      );
    }

    Widget photo() {
      return Consumer<GalleryProvider>(
          builder: (context, galleryProvider, child){
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Foto',
                      style: primaryTextStyle.copyWith(fontWeight: medium),
                    ),
                    AddButton(
                      text: 'Tambah Foto',
                      icon: Icons.add_circle_outlined,
                      onClick: () async {
                        final source = await choosePhotoSource(context);
                        if(source == null) return;

                        getPicture(source, galleryProvider);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                galleryProvider.galleries.isEmpty
                    ? const SizedBox()
                    : samplePhoto(),
              ],
            );
          }
      );
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
              return DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'Kategori produk harus dipilih';
                    }
                    return null;
                  },
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
                hintText: 'Masukkan nama produk',
                controller: productNameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama produk harus diisi';
                  } else if(productProvider.checkIfUsed(value)) {
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
                      groupValue: context.read<ProductProvider>().selectedValue,
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
      return Consumer2<ProductProvider, GalleryProvider>(
        builder: (context, productProvider, galleryProvider, child) {
          return SizedBox(
            height: 50,
            width: double.infinity, //supaya selebar layar
            child: productProvider.loading
                ? const LoadingButton()
                : DoneButton(
                    text: 'Simpan',
                    onClick: () {
                    if(_formKey.currentState!.validate()) {
                      handleAddData(productProvider, galleryProvider);
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
                photo(),
                const SizedBox(height: 20,),
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
        context.read<GalleryProvider>().galleries.clear();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: customAppBar(text: 'Form Tambah Produk'),
        body: content(),
      ),
    );
  }
}