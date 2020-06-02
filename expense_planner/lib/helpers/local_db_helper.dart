import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/transaction.dart' as tr;

class LocalDbHelper {
  static const TRANSACTIONS_DB_NAME = 'trans.db';
  static const TRANSACTIONS_TABLE_NAME = 'trx';

  static Future<Database> get database async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, TRANSACTIONS_DB_NAME),
      onCreate: (db, version) {
//        await db.delete(TRANSACTIONS_TABLE_NAME);
        return db.execute(
          'CREATE TABLE $TRANSACTIONS_TABLE_NAME (' +
              ' id TEXT PRIMARY KEY,' +
              ' title TEXT,' +
              ' date TEXT,' +
              ' amount TEXT' +
              ');',
        );
      },
//      onUpgrade: (db, v1, v2) {
//        db.delete(TRANSACTIONS_TABLE_NAME);
//      },
      version: 1,
    );
  }

  static Future storeTransaction(tr.Transaction transaction) async {
    final db = await database;
    Map<String, dynamic> values = {
      'id': transaction.id,
      'title': transaction.title,
      'date': transaction.date.toIso8601String(),
      'amount': transaction.amount.toString(),
    };
    await db.insert(
      TRANSACTIONS_TABLE_NAME,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<tr.Transaction>> get retrieveTransactions async {
    final db = await database;
//    print((await db.rawQuery(TRANSACTIONS_TABLE_NAME)).length);
//    if ((await db.rawQuery(TRANSACTIONS_TABLE_NAME)).length == 0) return [];
    try {
      return (await db.query(TRANSACTIONS_TABLE_NAME))
          .map(
            (map) => tr.Transaction(
              id: map['id'],
              title: map['title'],
              amount: double.parse(map['amount']),
              date: DateTime.parse(map['date']),
            ),
          )
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future deleteTransactionById(String id) async {
    final db = await database;
    await db
        .rawDelete('DELETE FROM $TRANSACTIONS_TABLE_NAME WHERE id = ?', [id]);
  }

  static Future updateTransaction(tr.Transaction transaction) async {
    final db = await database;
    await db.rawUpdate(
      'UPDATE $TRANSACTIONS_TABLE_NAME SET title = ?, date = ?, amount = ? '
      'WHERE id = ?',
      [
        transaction.title,
        transaction.date.toIso8601String(),
        transaction.amount.toString(),
        transaction.id,
      ],
    );
  }

  static Future deleteAllRecords() async {
    final db = await database;
    await db.rawQuery('DELETE FROM $TRANSACTIONS_TABLE_NAME');
  }
}
