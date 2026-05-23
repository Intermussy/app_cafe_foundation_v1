import 'package:app_foundation/bindings/app_logger.dart';
import 'package:app_foundation/features/store_menu/models/drink_cart_model.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:app_foundation/features/store_menu/repositories/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class CartRepository {
  final _logger = AppLogger();

  Future<bool> overWrite(DrinkCartModel drink) async {
    final db = await DatabaseProvider.database;
    try {
      await db.transaction((txt) async {
        //TODO: update to table 'cart_drinks'
        final drinkDb = drink.toDB();
        await txt.insert(
          'cart_drinks', //table name
          drinkDb, //object as map
          conflictAlgorithm:
              ConflictAlgorithm.replace, //if id exist, just replace
        );

        //TODO: clear old syrup joins where drink.id
        await txt.delete(
          'cart_drink_syrups',
          where: 'cart_drink_id = ?',
          whereArgs: [drink.id],
        );
        //TODO: clear old topping joins where drink.id
        await txt.delete(
          'cart_drink_toppings',
          where: 'cart_drink_id = ?',
          whereArgs: [drink.id],
        );

        //TODO: Update ToppingJoins
        for (final topping in drink.toppings) {
          await txt.insert('cart_drink_toppings', {
            'cart_drink_id': drink.id,
            'topping_id': topping.id,
          });
        }
        //TODO: Update SyrupJoins
        for (final syrup in drink.syrups) {
          await txt.insert('cart_drink_syrups', {
            'cart_drink_id': drink.id,
            'syrup_id': syrup.id,
          });
        }
      });
      return true;
    } catch (e) {
      _logger.error('failed to overwrite cart: $e');
    }
    return false;
  }

  Future<bool> overWriteAll(List<DrinkCartModel> drinks) async {
    List<bool> results = [];
    for (final d in drinks) {
      results.add(await overWrite(d));
    }
    return results.contains(false) ? false : true;
  }

  Future<List<DrinkCartModel>> readAll() async {
    final db = await DatabaseProvider.database;
    var hydrated = <DrinkCartModel>[];

    try {
      final cartRows = await db.query('cart_drinks');
      if (cartRows.isEmpty) return [];
      final drinkIds = cartRows.map((e) => e['id'] as int).toList();

      final toppingJoins = await db.query(
        'cart_drink_toppings',
        where: 'cart_drink_id IN (${drinkIds.join(',')})',
      );
      _logger.debug('[CART REPO] toppingJoins: ${toppingJoins.map((t) => t)}');

      final syrupJoins = await db.query(
        'cart_drink_syrups',
        where: 'cart_drink_id IN (${drinkIds.join(',')})',
      );
      _logger.debug('[CART REPO] syrupJoins: ${syrupJoins.map((t) => t)}');

      final toppingIds = toppingJoins
          .map((e) => e['topping_id'] as int)
          .toSet()
          .toList();
      _logger.debug('[CART REPO] toppingIds: ${toppingIds.join(',')}');

      final syrupsIds = syrupJoins
          .map((e) => e['syrup_id'] as int)
          .toSet()
          .toList();
      _logger.debug('[CART REPO] syrupIds: ${syrupsIds.join(',')}');

      final toppingRows = toppingIds.isEmpty
          ? []
          : await db.query(
              'toppings',
              where: 'id IN (${toppingIds.join(',')})',
            );
      _logger.debug('[CART REPO] toppingRows: $toppingRows');

      final syrupRows = syrupsIds.isEmpty
          ? []
          : await db.query('syrups', where: 'id IN (${syrupsIds.join(',')})');
      _logger.debug('[CART REPO] syrupRows: $syrupRows');

      final toppingMap = {
        for (var t in toppingRows)
          t['id']: Topping.fromMap(t as Map<String, dynamic>),
      };
      _logger.debug('[CART REPO] toppingMap: $toppingMap');

      final syrupMap = {
        for (var s in syrupRows)
          s['id']: Syrup.fromMap(s as Map<String, dynamic>),
      };
      _logger.debug('[CART REPO] syrupMap: $syrupMap');

      final hydratedAttempt = <DrinkCartModel>[];

      for (final row in cartRows) {
        final drink = DrinkCartModel.fromDB(row);

        final toppingIds = toppingJoins
            .where((t) => t['cart_drink_id'] == drink.id)
            .map((t) => t['topping_id'] as int)
            .toList();
        final syrupIds = syrupJoins
            .where((t) => t['cart_drink_id'] == drink.id)
            .map((t) => t['syrup_id'] as int)
            .toList();
        List<Topping> toppings = toppingIds
            .map((id) => toppingMap[id]!)
            .toList();
        _logger.debug(
          '[CART REPO] toppings list: ${toppings.map((t) => t.toMap())}',
        );

        List<Syrup> syrups = syrupIds.map((id) => syrupMap[id]!).toList();
        _logger.debug(
          '[CART REPO] syrups list: ${syrups.map((s) => s.toMap())}',
        );

        hydratedAttempt.add(drink.copyWith(toppings: toppings, syrups: syrups));
      }

      hydrated = List<DrinkCartModel>.unmodifiable(hydratedAttempt);
      _logger.info(
        '[CART REPO] read successful : ${hydrated.map((drink) => drink.toMap())}',
      );
    } catch (e) {
      _logger.error('[CART REPO] failed to fetch: $e');
    }
    return hydrated;
  }

  Future<void> removeById({required int id}) async {
    final db = await DatabaseProvider.database;
    try {
      await db.transaction((txn) async {
        await txn.delete(
          'cart_drink_toppings',
          where: 'cart_drink_id = ?',
          whereArgs: [id],
        );
        await txn.delete(
          'cart_drink_syrups',
          where: 'cart_drink_id = ?',
          whereArgs: [id],
        );
        await txn.delete('cart_drinks', where: 'id = ?', whereArgs: [id]);
      });
      _logger.info("[CART REPO] delete successful");
    } catch (e) {
      _logger.error("[CART REPO] ${e.toString}");
    }
  }

  Future<void> clearAll() async {
    final db = await DatabaseProvider.database;
    db.transaction((txt) async {
      late List<int> toppingIds;
      late List<int> syrupIds;

      final cartRows = await txt.query('cart_drinks');
      if (cartRows.isEmpty) return;

      await txt.delete('cart_drinks');
    });
  }

  Future<int> getCount() async {
    final db = await DatabaseProvider.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM cart_drinks',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
