import 'package:flutter/material.dart';
import 'package:flutter_dblocal_sqflite/component/custom_text_field.dart';
import 'package:flutter_dblocal_sqflite/config/db_helper.dart';
import 'package:flutter_dblocal_sqflite/models/category_model.dart';

import 'category_page.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Catgeory Name',
            hintext: 'Enter Catgeory Name',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final category = CategoryModel(name: _nameController.text);

              final result = await DbHelper().insertCategory(category);

              if (result > 0 && mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryPage()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Category Added'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Failed to Add Category'),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
