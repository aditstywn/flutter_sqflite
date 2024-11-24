import 'package:flutter/material.dart';
import 'package:flutter_dblocal_sqflite/presentation/setting/pages/product/product_page.dart';

import '../widgets/setting_card.dart';
import 'category/category_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting Page',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        children: [
          SettingCard(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductPage()));
            },
            title: 'Product',
            image: 'assets/images/box.png',
            width: 100,
            height: 100,
          ),
          SettingCard(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoryPage()));
            },
            title: 'Category',
            image: 'assets/images/categorization.png',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}
