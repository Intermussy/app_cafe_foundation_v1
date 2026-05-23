import 'dart:convert';
import 'dart:developer' as dev;
import 'package:app_foundation/bindings/app_config.dart';
import 'package:app_foundation/bindings/app_logger.dart';
import 'package:app_foundation/bindings/http_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:app_foundation/features/store_menu/models/drink_catalog_model.dart';
import 'package:app_foundation/features/store_menu/repositories/database_provider.dart';

class CatalogRepository {
  final AppLogger _appLogger = AppLogger();

  Future<List<DrinkCatalogModel>> readAll() async {
    final db = await DatabaseProvider.database;
    try {
      final List<Map<String, Object?>> query = await db.query('catalog_cache');
      if (query.isNotEmpty) {
        _appLogger.info('[CATALOG REPOSITORY] cache detected.');
        final List<DrinkCatalogModel> result = query.map((d) {
          final drinkCatalog = DrinkCatalogModel.fromDB(d);
          _appLogger.debug(
            '[DrinkCatalogModel.fromDB] ${drinkCatalog.toMap()}',
          );
          return drinkCatalog;
        }).toList();

        return result;
      }
      _appLogger.info(
        '[CATALOG REPOSITORY] no cache. fetching from network...',
      );
      final networkData = await CatalogNetwork.fetch;
      final batch = db.batch();
      for (final item in networkData) {
        _appLogger.debug('[NETWORK RESULT] ${item.toMap()}');
        final mapDBModel = item.toDB();
        batch.insert('catalog_cache', mapDBModel);
      }
      await batch.commit(noResult: true);
      return networkData;
    } catch (e, stack) {
      dev.log('[DB] error loading catalog_cache: $e');
      dev.log(stack.toString());
    }
    return [];
  }
}

class CatalogNetwork {
  //TODO: define getter to fetch API
  static Future<List<DrinkCatalogModel>> get fetch => _getCatalog();

  //TODO: declare client
  static final http.Client _client = HttpInterceptor();
  static final baseUrl = AppConfig().apiBaseUrl;
  //TODO: make HTTP call with GET method
  static Future<List<DrinkCatalogModel>> _getCatalog() async {
    //TODO: Request HTTP GET
    final response = await _client.get(Uri.parse('$baseUrl/catalog.json'));

    //TODO: Check Status Code
    if (response.statusCode == 200) {
      dev.log('[HTTP ${response.statusCode}] fetch Catalog');
      final decoded = jsonDecode(response.body) as List<dynamic>;
      AppLogger().info(
        '[DECODED] ${decoded.toList().toString()}',
      ); // before mapping
      final mapped = decoded.map((drink) {
        AppLogger().debug('[MAP] ${drink.toString()}'); //before mapping
        final mappedDrink = DrinkCatalogModel.fromMap(
          drink as Map<String, dynamic>,
        );
        AppLogger().debug(
          '[CatalogModel.fromMap] ${mappedDrink.toMap().toString()}',
        );
        return mappedDrink;
      }).toList();
      return mapped;
    } else {
      dev.log('[HTTP ${response.statusCode}] problem fetching Catalog');
      return [];
    }
  }
}
