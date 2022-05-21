import 'package:budiberas_admin_9701/providers/gallery_provider.dart';
import 'package:budiberas_admin_9701/providers/product_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/add_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/app_bar.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/cancel_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/delete_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/edit_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budiberas_admin_9701/constants.dart' as constants;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';
import 'dart:io';

class FormEditPhotoProduct extends StatefulWidget {
  final int productId;
  final String productName;
  const FormEditPhotoProduct({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  _FormEditPhotoProductState createState() => _FormEditPhotoProductState();
}

class _FormEditPhotoProductState extends State<FormEditPhotoProduct> {
  bool statusChanged = false;

  @override
  void initState() {
    getInit();
    super.initState();
  }

  getInit() async {
    Provider.of<GalleryProvider>(context, listen: false).getGalleries(widget.productId);
  }

  @override
  void dispose() {
    statusChanged = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("== this is gallery==");
    print("status changed: $statusChanged");

    Future<ImageSource?> choosePhotoSource(context) async {
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

    handleAddPhoto(GalleryProvider galleryProvider) async{
      final source = await choosePhotoSource(context);
      if(source == null) return;

      try{
        final imgPicked = await ImagePicker().pickImage(
          source: source,
          imageQuality: 85,
          maxWidth: 540,
          maxHeight: 960,
        );
        if(imgPicked == null) return;

        if(await galleryProvider.addNewPhoto(
          productId: widget.productId,
          photoUrl: File(imgPicked.path),
        )) {
          galleryProvider.getGalleries(widget.productId);

          statusChanged = true;
          print("tambah: $statusChanged");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Foto berhasil ditambahkan'),
              backgroundColor: secondaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Foto gagal ditambahkan'),
              backgroundColor: secondaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }on PlatformException catch (e) {
        print('Gagal mengambil foto: $e');
      }
    }

    handleEditPhoto(GalleryProvider galleryProvider, int idPhoto) async {
      final source = await choosePhotoSource(context);
      if(source == null) return;

      try{
        final imgPicked = await ImagePicker().pickImage(
          source: source,
          imageQuality: 85,
          maxWidth: 540,
          maxHeight: 960,
        );
        if(imgPicked == null) return;

        if(await galleryProvider.editPhoto(
          idPhoto: idPhoto,
          photoUrl: File(imgPicked.path),
        )) {
          galleryProvider.getGalleries(widget.productId);

          statusChanged = true;
          print("edit: $statusChanged");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Foto berhasil diedit'),
              backgroundColor: secondaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Foto gagal diedit'),
              backgroundColor: secondaryColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }on PlatformException catch (e) {
        print('Gagal mengambil foto: $e');
      }
    }

    handleDeletePhoto(GalleryProvider galleryProvider, int idPhoto) async{
      if(await galleryProvider.deletePhoto(idPhoto: idPhoto)) {
        galleryProvider.getGalleries(widget.productId);

        statusChanged = true;
        print("hapus: $statusChanged");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Foto berhasil dihapus'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Foto gagal diedit'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    Future<void> areYouSureDialog({
      required GalleryProvider galleryProvider,
      required int idPhoto,
      required String url,
    }) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    constants.urlPhoto + url,
                    width: 100,
                    height: 100,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      return Container(
                          color: const Color(0xffDDDDDF),
                          child: Icon(
                            Icons.image_not_supported_rounded,
                            color: secondaryTextColor,
                            size: 100,
                          )
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 12,),
                  Text(
                    'Apakah Anda yakin ingin menghapus foto ini?',
                    style: primaryTextStyle, textAlign: TextAlign.center,
                  ),
                  SizedBox(height: defaultMargin,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CancelButton(
                          onClick: () {
                            Navigator.pop(context);
                          }
                      ),
                      const SizedBox(width: 50,),
                      DoneButton(
                          text: 'Hapus',
                          onClick: () {
                            handleDeletePhoto(galleryProvider, idPhoto);
                          }
                      ),
                    ]
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget photoData() {
      return Consumer<GalleryProvider>(
        builder: (context, data, child) {
          return Flexible(
            child: ListView.builder(
              itemCount: data.productGalleries.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String url = data.productGalleries[index].url.toString();
                int? idPhoto = data.productGalleries[index].id;
                return Column(
                  children: [
                    ListTile(
                      title: Stack(
                        children: [
                          Image.network(
                            constants.urlPhoto + url,
                            width: 100,
                            height: 100,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Container(
                                  color: const Color(0xffDDDDDF),
                                  child: Icon(
                                    Icons.image_not_supported_rounded,
                                    color: secondaryTextColor,
                                    size: 100,
                                  )
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                          index == 0
                              ? Container(
                            padding: const EdgeInsets.all(7),
                            color: const Color(0xffD7F1EA),
                            child: Text(
                              'Sampul',
                              style: priceTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: semiBold,
                              ),
                            ),
                          )
                              : const SizedBox(),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          EditButton(
                            onClick: () {
                              handleEditPhoto(data, idPhoto!);
                            },
                          ),
                          const SizedBox(width: 20,),
                          DeleteButton(
                            onClick: () {
                              areYouSureDialog(url: url, galleryProvider: data, idPhoto: idPhoto!);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
      );
    }

    Widget contentWithData() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: 150,
                child: Consumer<GalleryProvider>(
                  builder: (context, data, child){
                    return AddButton(
                      onClick: () {
                        handleAddPhoto(data);
                      },
                      text: 'Tambah Foto',
                      icon: Icons.add_circle_outlined,
                    );
                  }
                ),
              ),
            ),
          ),
          Text(
            'Daftar Foto Produk ${widget.productName}',
            style: primaryTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12,),
          photoData(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 30,
            ),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child){
                      return DoneButton(
                        onClick: () {
                          //jika status changednya true, maka produk akan direload shg menampilkan data dgn foto yg baru
                          if(statusChanged == true) {
                            productProvider.getProducts();
                          }
                          context.read<GalleryProvider>().productGalleries.clear();
                          Navigator.popUntil(context, ModalRoute.withName('/manage-product'));
                        },
                        text: 'Selesai',
                      );
                    }
                  ),
                )
            ),
          ),
        ],
      );
    }

    Widget galleryEmpty() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/empty-image-icon.png', width: MediaQuery.of(context).size.width - (10 * defaultMargin),),
            const SizedBox(height: 20,),
            Text(
              'Belum ada foto untuk produk ${widget.productName}',
              textAlign: TextAlign.center,
              style: primaryTextStyle.copyWith(
                  fontWeight: medium,
                  fontSize: 16),
            ),
            const SizedBox(height: 36,),
            SizedBox(
              width: 180,
              child: Consumer<GalleryProvider>(
                builder: (context, data, child){
                  return AddButton(
                    onClick: () {
                      handleAddPhoto(data);
                    },
                    text: 'Tambahkan Foto',
                    icon: Icons.add_a_photo,
                  );
                }
              ),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: 180,
              child: CancelButton(
                onClick: () {
                  context.read<GalleryProvider>().productGalleries.clear();
                  Navigator.popUntil(context, ModalRoute.withName('/manage-product'));
                },
                text: 'Kembali',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    Widget checkGallery() {
      return Consumer<GalleryProvider>(
        builder: (context, data, child){
          return SizedBox(
              child: data.loading
                  ? const Center(
                  child: CircularProgressIndicator()
              )
                  : data.productGalleries.isEmpty
                  ? galleryEmpty()
                  : contentWithData()
          );
        }
      );
    }

    return WillPopScope(
      onWillPop: () {
        if(statusChanged == true) {
          context.read<ProductProvider>().getProducts();
        }
        context.read<GalleryProvider>().productGalleries.clear();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: customAppBar(
            text: 'Kelola Foto Produk'
        ),
        body: checkGallery(),
      ),
    );
  }
}
