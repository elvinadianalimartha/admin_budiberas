import 'package:budiberas_admin_9701/views/widgets/reusable/add_button.dart';
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

  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<CategoryProvider>(context, listen: false).getCategories();
    Provider.of<GalleryProvider>(context, listen: false).galleries;
  }

  @override
  Widget build(BuildContext context) {
    print('=== build from scratch ===');

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
              return ListView.builder(
                  itemCount: galleryProvider.galleries.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(16),
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
                  }
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
                    addButton(
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
              List<CategoryModel> listCategories = data.categories.toList();
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
                      child: Text(item.category_name, style: primaryTextStyle,),
                      value: item.id,
                    );
                  }).toList(),
                  onChanged: (_) {
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
      ),
    );
  }
}