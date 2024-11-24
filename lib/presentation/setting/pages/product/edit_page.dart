// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_dblocal_sqflite/models/product_model.dart';
import 'package:flutter_dblocal_sqflite/presentation/setting/pages/product/product_page.dart';

import '../../../../config/db_helper.dart';
import '../../widgets/dropDown_model.dart';

class EditPage extends StatefulWidget {
  final ProductModel product;
  final String? categoryName;
  const EditPage({
    super.key,
    required this.product,
    this.categoryName,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  Uint8List? _imageBase64;
  String? selectedCategory;

  @override
  void initState() {
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _stockController.text = widget.product.stock.toString();
    selectedCategory = widget.product.id_category.toString();

    if (widget.product.image != null) {
      _imageBase64 = widget.product.image!;
    }

    loadCategories();

    super.initState();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _imageBase64 = bytes;
      });
    }
  }

  List<DropdownModel> categories = [];

  Future<void> loadCategories() async {
    try {
      final categoryList = await DbHelper().getCategories();
      setState(() {
        categories = categoryList
            .map((category) => DropdownModel(
                  name: category.name!,
                  value: category.id.toString(),
                ))
            .toList();
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                image: _imageBase64 != null
                    ? DecorationImage(
                        image: MemoryImage(_imageBase64!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _imageBase64 == null
                  ? const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 50,
                      ),
                    )
                  : null,
            ),
          ),
          const Text(
            'Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Product Name',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Price',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Product Price',
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Stock',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _stockController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Product Stock',
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            hint: selectedCategory == null
                ? const Text('Category')
                : widget.categoryName == null
                    ? const Text('Category')
                    : Text(widget.categoryName!),
            items: categories.map((DropdownModel category) {
              return DropdownMenuItem<String>(
                value: category.value,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedCategory = value;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final product = ProductModel(
                id: widget.product.id,
                id_category: selectedCategory != null
                    ? int.tryParse(selectedCategory!)
                    : null,
                name: _nameController.text,
                price: int.parse(_priceController.text),
                stock: int.parse(_stockController.text),
                image: _imageBase64,
              );

              final response = await DbHelper().update(product);

              if (response > 0) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('Product ${product.id} updated successfully '),
                ));

                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductPage()));
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('Failed to update product ${product.id}'),
                ));
              }
            },
            child: const Text('Update Product'),
          ),
        ],
      ),
    );
  }
}
