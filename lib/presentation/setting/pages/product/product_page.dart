import 'package:flutter/material.dart';
import 'package:flutter_dblocal_sqflite/presentation/setting/pages/product/add_page.dart';

import '../../../../config/db_helper.dart';
import '../../../../models/product_model.dart';
import 'edit_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    setState(() {
      _products = DbHelper().getProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Page'),
      ),
      body: FutureBuilder(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Data is empty'),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];

                final category = product.id_category != null
                    ? DbHelper().getCategoryById(product.id_category!)
                    : Future.value(null);

                return FutureBuilder(
                  future: category,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return Card(
                        color: Colors.blue[50],
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(
                                  product: product,
                                  categoryName: null,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: ClipOval(
                              child: product.image != null
                                  ? Image.memory(
                                      product.image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'No Category',
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await DbHelper().deleteProduct(product);
                              setState(() {
                                _products = DbHelper().getProducts();
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final category = snapshot.data!;
                      return Card(
                        color: Colors.blue[50],
                        child: ListTile(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(
                                  product: product,
                                  categoryName: category[0].name!,
                                ),
                              ),
                            );
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            child: ClipOval(
                              child: product.image != null
                                  ? Image.memory(
                                      product.image!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            category[0].name ?? 'No Category',
                          ),
                          trailing: IconButton(
                            onPressed: () async {
                              await DbHelper().deleteProduct(product);
                              setState(() {
                                _products = DbHelper().getProducts();
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AddPage()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
