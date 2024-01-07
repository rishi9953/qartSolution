import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'my_database.db';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE example_table  (
        id INTEGER PRIMARY KEY,
        name TEXT,
        mrp INTEGER,
        gender TEXT,
        category TEXT,
        fit TEXT,
        qrCode TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertData(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('example_table', row);
  }

  Future<List<Map<String, dynamic>>> queryAllData() async {
    Database db = await database;
    return await db.query('example_table');
  }

  Future<int> updateData(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db
        .update('example_table', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(int id) async {
    Database db = await database;
    return await db.delete('example_table', where: 'id = ?', whereArgs: [id]);
  }
}
