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
    TextEditingController categoryController = TextEditingController(text: '');

    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);

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
                                    editButton(
                                        onClick: () {
                                        }
                                    ),
                                    const SizedBox(width: 20,),
                                    deleteButton(
                                        onClick: () {
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

    Future<void> showDialogAdd() async {
      List<CategoryModel> listCategories = categoryProvider.categories;

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
                      'Tambah Kategori',
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
                      controller: categoryController,
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
                        cancelButton(
                          onClick: () {
                            Navigator.pop(context);
                            categoryController.clear();
                          }
                        ),
                        doneButton(
                          text: 'Simpan',
                          onClick: () {
                            if(_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Data berhasil tersimpan')),
                              );
                              Navigator.pop(context);
                              categoryController.clear();
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

    Widget content() {
      return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 180,
                  child: addButton(
                    onClick: () {
                      showDialogAdd();
                    },
                    text: 'Tambah Kategori',
                    icon: Icons.add_circle_outlined,
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
