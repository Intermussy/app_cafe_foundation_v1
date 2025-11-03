import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static Database? _db;
  static const _dbName = 'store_menu.db';
  static const _dbVersion = 2;

  // Prevent accidental construction
  DatabaseProvider._();

  static Future<Database> get database async {
    if (_db != null) return _db!;
    return await _initDb();
  }

  static Future<Database> _initDb() async {
    dev.log('[DB] init DB...');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        final sql = await rootBundle.loadString(
          'assets/sql/store_menu/schema.sql',
        );
        for (final stmt in sql.split(';')) {
          if (stmt.trim().isNotEmpty) await db.execute(stmt);
        }
      },
    );
    dev.log('[DB] DB schema initialized!');

    return _db!;
  }

  static Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$_dbName';
    await deleteDatabase(path);
    print('Database deleted: $path');
  }

  static Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
