import 'dart:convert';
import 'dart:typed_data';

class ProductModel {
  final int? id;
  final int? id_category;
  final String name;
  final int price;
  final int stock;
  final Uint8List? image;

  ProductModel({
    this.id,
    this.id_category,
    required this.name,
    required this.price,
    required this.stock,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'id_category': id_category,
      'name': name,
      'price': price,
      'stock': stock,
      'image': image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      id_category: map['id_category'] as int?,
      name: map['name'] as String,
      price: map['price'] as int,
      stock: map['stock'] as int,
      image: map['image'] as Uint8List?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
