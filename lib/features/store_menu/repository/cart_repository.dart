import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class CartRepository {
  Future<List<DrinkCartBase>> getAll();
  Future<void> add(DrinkCartBase drink);
  Future<void> update(DrinkCartBase drink);
  Future<void> remove(int id);
  Future<void> clear();
}

class SqliteCartRepository implements CartRepository {
  Database? _db;
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath);
    _db = await openDatabase(path);
  }

  @override
  Future<void> add(DrinkCartBase drink) async {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> clear() async {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<List<DrinkCartBase>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> remove(int id) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  Future<void> update(DrinkCartBase drink) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
