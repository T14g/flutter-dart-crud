import 'db_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _connection;

  Repository() {
    _connection = DatabaseConnection();
  }

  static Database _database; //setter

  //getter
  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _connection.setDatabase(); //else
    return _database;
  }

  save(table , data) async {
    var conn = await database;
    return await conn.insert(table, data);
  }

  getAll(table) async {
    var conn = await database;
    return await conn.query(table);
  }
}