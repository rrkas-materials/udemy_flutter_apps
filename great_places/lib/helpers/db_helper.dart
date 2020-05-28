import 'package:great_places/providers/places.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static Future<sql.Database> get _database async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(${Places.ID} TEXT PRIMARY KEY, ${Places.TITLE} TEXT, ${Places.IMAGE} TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await _database;
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await _database;
    return db.query(table);
  }
}
