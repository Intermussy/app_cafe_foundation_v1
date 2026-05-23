import 'dart:convert';
import 'dart:developer' as dev;
import 'package:app_foundation/bindings/app_config.dart';
import 'package:app_foundation/bindings/app_logger.dart';
import 'package:app_foundation/bindings/http_interceptor.dart';
import 'package:app_foundation/features/store_menu/models/syrup.dart';
import 'package:app_foundation/features/store_menu/models/topping.dart';
import 'package:http/http.dart' as http;
import 'package:app_foundation/features/store_menu/repositories/database_provider.dart';
import 'package:sqflite/sqflite.dart';

class AddonRepository {
  Future<(List<Topping>, List<Syrup>)> readAll() async {
    final db = await DatabaseProvider.database;

    try {
      final List<Map<String, Object?>> queryTopping = await db.query(
        'toppings',
      );
      final List<Map<String, Object?>> querySyrup = await db.query('syrups');

      //TODO: If query not empty, map the objects to memory
      if (queryTopping.isNotEmpty && querySyrup.isNotEmpty) {
        final List<Topping> toppings = queryTopping.map((t) {
          return Topping.fromMap(t);
        }).toList();
        final syrups = querySyrup.map((s) {
          return Syrup.fromMap(s);
        }).toList();
        return (toppings, syrups);
      }

      //TODO: If query result is empty, fetch from network
      final networkData = await AddonNetwork.fetch;
      final (toppings, syrups) = networkData;
      final batch = db.batch();
      for (final t in toppings) {
        batch.insert(
          'toppings',
          t.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      for (final s in syrups) {
        batch.insert(
          'syrups',
          s.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
      await batch.commit(noResult: true);
      return networkData;
    } catch (e, stack) {
      dev.log('[DB] error loading reading AddonRepository: $e');
      dev.log(stack.toString());
    }
    return (<Topping>[], <Syrup>[]);
  }
}

class AddonNetwork {
  //TODO: define getter to fetch API
  static Future<(List<Topping>, List<Syrup>)> get fetch => _getAddon();

  //TODO: declare client
  static final http.Client _client = HttpInterceptor();
  static final baseUrl = AppConfig().apiBaseUrl;

  //TODO: make HTTP call with GET method
  static Future<(List<Topping>, List<Syrup>)> _getAddon() async {
    //TODO: Request HTTP GET
    final resTopping = await _client.get(Uri.parse('$baseUrl/toppings.json'));
    final resSyrup = await _client.get(Uri.parse('$baseUrl/syrups.json'));

    //TODO: Check Status Code
    if (resTopping.statusCode == 200 && resSyrup.statusCode == 200) {
      dev.log(
        '[HTTP ${resTopping.statusCode} ${resSyrup.statusCode}] fetch Toppings & syrups',
      );

      //TODO: Decode Json to List
      final decodedTopping = jsonDecode(resTopping.body) as List<dynamic>;
      final decodedSyrup = jsonDecode(resSyrup.body) as List<dynamic>;
      AppLogger().info(
        "[Decode Toppings] ${decodedTopping.map((t) => t.toString())}",
      );

      AppLogger().info(
        "[Decode Syrups] ${decodedSyrup.map((t) => t.toString())}",
      );

      //TODO: List<Map> to List<Topping> & List<Syrup>
      final mappedTopping = decodedTopping.map((t) {
        return Topping.fromMap(t as Map<String, dynamic>);
      }).toList();

      AppLogger().info(
        "[Map Toppings] ${mappedTopping.map((t) => t.toString())}",
      );
      final mappedSyrup = decodedSyrup.map((s) {
        return Syrup.fromMap(s as Map<String, dynamic>);
      }).toList();
      AppLogger().info("[Map Syrups] ${mappedSyrup.map((t) => t.toString())}");

      return (mappedTopping, mappedSyrup);
    } else {
      dev.log(
        '[HTTTP ${resTopping.statusCode} ${resSyrup.statusCode}] problem fetching Toppings & Syrups',
      );
      return (<Topping>[], <Syrup>[]);
    }
  }
}
