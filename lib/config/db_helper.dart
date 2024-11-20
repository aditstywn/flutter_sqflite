import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';

class DbHelper {
  Database? _database;

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE product(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT ,
      price INTEGER ,
      stock INTEGER,
      image BLOB 
    )
  ''');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = dbPath + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get getDB async {
    _database ??= await _initDB('product.db');
    return _database!;
  }

  Future<int> insert(ProductModel product) async {
    final db = await getDB;
    try {
      return await db.insert('product', product.toMap());
    } catch (e) {
      throw Exception('Gagal menambahkan data: $e');
    }
  }

  Future<List<ProductModel>> getProducts() async {
    final db = await getDB;
    try {
      final List<Map<String, dynamic>> results = await db.query(
        'product',
        orderBy: 'id DESC',
      );
      return results.map((res) => ProductModel.fromMap(res)).toList();
    } catch (e) {
      throw Exception('Gagal mendapatkan data: $e');
    }
  }

  Future<int> update(ProductModel product) async {
    final db = await getDB;
    try {
      return await db.update(
        'product',
        product.toMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      throw Exception('Gagal memperbarui data: $e');
    }
  }

  Future<int> delete(ProductModel product) async {
    final db = await getDB;
    try {
      return await db.delete(
        'product',
        where: 'id = ?',
        whereArgs: [product.id],
      );
    } catch (e) {
      throw Exception('Gagal menghapus data: $e');
    }
  }
}
