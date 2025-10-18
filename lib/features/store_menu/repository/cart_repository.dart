import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartRepository {
  Database? _db;
  static const _dbName = 'cart.db';
  static final _dbVersion = 1;

  Future<Database> _initDb() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        final sql = await rootBundle.loadString('assets/sql/schema.sql');
        for (final stmt in sql.split(';')) {
          if (stmt.trim().isNotEmpty) await db.execute(stmt);
        }
      },
    );
    return _db!;
  }

  Future<List<DrinkCartModel>> readAll() async {
    final cartRows = await _db!.query('cart_drinks');
    if (cartRows.isEmpty) return [];
    final drinkIds = cartRows.map((e) => e['id'] as int).toList();

    final toppingJoins = await _db!.query(
      'cart_drink_toppings',
      where: 'cart_drink_id IN (${drinkIds.join(',')})',
    );

    final syrupJoins = await _db!.query(
      'cart_drink_syrups',
      where: 'cart_drink_id IN (${drinkIds.join(',')})',
    );

    final toppingIds = toppingJoins
        .map((e) => e['topping_id'] as int)
        .toSet()
        .toList();
    final syrupsIds = syrupJoins
        .map((e) => e['syrup_id'] as int)
        .toSet()
        .toList();
    final toppingRows = toppingIds.isEmpty
        ? []
        : await _db!.query(
            'toppings',
            where: 'id IN (${toppingIds.join(',')})',
          );
    final syrupRows = syrupsIds.isEmpty
        ? []
        : await _db!.query('syrups', where: 'id IN (${syrupsIds.join(',')})');

    final toppingMap = {
      for (var t in toppingRows) t['id']: Topping.fromJson(t),
    };
    final syrupMap = {for (var s in syrupRows) s['id']: Syrup.fromJson(s)};

    final hydrated = <DrinkCartModel>[];

    for (final row in cartRows) {
      final drink = DrinkCartDB.fromMap(row);

      final toppingIds = toppingJoins
          .where((t) => t['drink_id'] == drink.id)
          .map((t) => t['topping_id'] as int)
          .toList();
      final syrupIds = syrupJoins
          .where((t) => t['drink_id'] == drink.id)
          .map((t) => t['syrup_id'] as int)
          .toList();
      List<Topping> toppings = toppingIds.map((id) => toppingMap[id]!).toList();
      List<Syrup> syrups = syrupIds.map((id) => syrupMap[id]!).toList();

      hydrated.add(DrinkCartModel.fromDB(toppings, syrups, drink));
    }

    return hydrated;
  }
}
