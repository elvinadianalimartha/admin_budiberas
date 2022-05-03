// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/providers/category_provider.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/cancel_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/done_button.dart';
import 'package:budiberas_admin_9701/views/widgets/reusable/line_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';
import '../../theme.dart';
import '../widgets/reusable/add_button.dart';
import '../widgets/reusable/app_bar.dart';
import '../widgets/reusable/delete_button.dart';
import '../widgets/reusable/edit_button.dart';

class ManageCategoryPage extends StatefulWidget {
  const ManageCategoryPage({Key? key}) : super(key: key);

  @override
  _ManageCategoryPageState createState() => _ManageCategoryPageState();
}

class _ManageCategoryPageState extends State<ManageCategoryPage> {
  @override
  void initState() {
    super.initState();
    getInit();
  }

  getInit() async {
    await Provider.of<CategoryProvider>(context, listen: false).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    print("=== build from scratch ===");

    final _formKey = GlobalKey<FormState>();
    TextEditingController addCategoryController = TextEditingController(text: '');
    String? status = '';

    handleEditData({
      required CategoryProvider categoryProvider,
      required int idToUpdate,
      required TextEditingController updateCategoryController
    }) async {
      if(await categoryProvider.updateCategory(id: idToUpdate, category_name: updateCategoryController.text)) {
        Navigator.pop(context);
        updateCategoryController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil diperbarui'), backgroundColor: secondaryColor, duration: Duration(seconds: 2),),
        );
        categoryProvider.getCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data gagal diperbarui'), backgroundColor: alertColor, duration: Duration(seconds: 2),),
        );
      }
    }

    handleAddData(CategoryProvider categoryProvider) async {
      if(await categoryProvider.createCategory(category_name: addCategoryController.text)) {
        Navigator.pop(context);
        addCategoryController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil tersimpan'), backgroundColor: secondaryColor, duration: Duration(seconds: 2),),
        );
        categoryProvider.getCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data gagal ditambahkan'), backgroundColor: alertColor, duration: Duration(seconds: 2),),
        );
      }
    }

    handleDeleteData(CategoryProvider categoryProvider, int id) async {
      if(await categoryProvider.deleteCategory(id: id)) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus'), backgroundColor: secondaryColor, duration: Duration(seconds: 2),),
        );
        categoryProvider.getCategories();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data gagal dihapus'), backgroundColor: alertColor, duration: Duration(seconds: 2),),
        );
      }
    }

    Future<void> areYouSureDialog({
      required String name,
      required CategoryProvider categoryProvider,
      required int id
    }) async {
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          child: AlertDialog(
            insetPadding: EdgeInsets.all(40),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffffdeeb),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.question_mark, size: 30, color: alertColor,)),
                  SizedBox(height: 12,),
                  Text(
                    'Apakah Anda yakin untuk menghapus kategori $name?',
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
                      SizedBox(width: 50,),
                      DoneButton(
                          text: 'Hapus',
                          onClick: () {
                            handleDeleteData(categoryProvider, id);
                          }
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Future<void> openDialogAddorEdit({
      required CategoryProvider data,
      TextEditingController? updateCategoryController,
      int? id
    }) async {
      List<CategoryModel> listCategories = data.categories;

      bool checkIfUsed(String? value) {
        var same = listCategories.where((element) => element.category_name.toLowerCase() == value?.toLowerCase());

        if(same.isNotEmpty) {
          return true;
        }else {
          return false;
        }
      }

      return showDialog(
        context: context,
        builder: (BuildContext context) => Container(
          width: MediaQuery.of(context).size.width - (2 * defaultMargin),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      status == 'Tambah' ? 'Tambah Kategori' : 'Ubah Kategori',
                      style: primaryTextStyle.copyWith(
                        fontWeight: semiBold,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      'Nama Kategori',
                      style: greyTextStyle.copyWith(
                        fontWeight: medium,
                        fontSize: 13,
                      ),
                    ),
                    LineTextField(
                      hintText: 'Masukkan nama kategori',
                      actionKeyboard: TextInputAction.done,
                      controller: status == 'Tambah' ? addCategoryController : updateCategoryController,
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Nama kategori harus diisi';
                        } else if(checkIfUsed(value)) {
                          return 'Nama kategori sudah pernah digunakan';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 36,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CancelButton(
                            onClick: () {
                              Navigator.pop(context);
                              addCategoryController.clear();
                              data.categories.where((element) => element.id == id).forEach((element) {
                                String previousCategory = element.category_name;
                                updateCategoryController?.text = previousCategory;
                              });
                            }
                        ),
                        DoneButton(
                            text: 'Simpan',
                            onClick: () {
                              if(_formKey.currentState!.validate()) {
                                status == 'Tambah' ? handleAddData(data)
                                                  : handleEditData(categoryProvider: data, idToUpdate: id!, updateCategoryController: updateCategoryController!);
                              }
                            }
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget data() {
      return Consumer<CategoryProvider>(
        builder: (context, data, child) {
          return Flexible(
              child: SizedBox(
                  child: data.loading ?
                    Center(
                      child: CircularProgressIndicator(),
                    )
                    :
                    ListView.builder(
                      itemCount: data.categories.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        CategoryModel category = data.categories[index];
                        TextEditingController updateCategoryController = TextEditingController(text: category.category_name);
                        int id = category.id;
                        return Column(
                          children: [
                            ListTile(
                                title: Text(
                                  category.category_name,
                                  style: primaryTextStyle.copyWith(
                                    fontWeight: medium,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    EditButton(
                                      onClick: () {
                                        status = 'Ubah';
                                        openDialogAddorEdit(
                                            data: data,
                                            updateCategoryController: updateCategoryController,
                                            id: id,
                                        );
                                      }
                                    ),
                                    const SizedBox(width: 20,),
                                    DeleteButton(
                                      onClick: () {
                                        areYouSureDialog(
                                          name: category.category_name,
                                          id: id,
                                          categoryProvider: data,
                                        );
                                      }
                                    )
                                  ],
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                thickness: 1,
                              ),
                            ),
                          ],
                        );
                      },
                  )
              )
          );
        },
      );
    }

    Widget content() {
      return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 180,
                  child: Consumer<CategoryProvider>(
                    builder: (context, data, child) {
                      return AddButton(
                        onClick: () {
                          status = 'Tambah';
                          openDialogAddorEdit(
                              data: data,
                              updateCategoryController: null,
                              id: null
                          );
                        },
                        text: 'Tambah Kategori',
                        icon: Icons.add_circle_outlined,
                      );
                    }
                  ),
                ),
              ),
            ),
            data(),
        ]
      );
    }

    return Scaffold(
      appBar: customAppBar(
          text: 'Kelola Kategori'
      ),
      body: content(),
    );
  }
}
