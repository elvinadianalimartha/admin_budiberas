// ignore_for_file: prefer_const_constructors
import 'package:budiberas_admin_9701/providers/category_provider.dart';
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
  Widget build(BuildContext context) {

    CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context);
    //List<CategoryModel> category = categoryProvider.categories;

    Widget data() {
      return ListView.builder(
        itemCount: categoryProvider.categories.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          CategoryModel category = categoryProvider.categories[index];
          return Column(
            children: [
              ListTile(
                title: Text(
                  category.name,
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
                  },
                  text: 'Tambah Kategori',
                  icon: Icons.add_circle_outlined,
                ),
              ),
            ),
          ),
          data(),
        ],
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
