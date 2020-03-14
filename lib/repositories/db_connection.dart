import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_crud');
    var database = await openDatabase(path, version: 1, onCreate: _onCreateDb);

    return database;
  }

  //Private _
  _onCreateDb(Database db, int version) async{
    await db.execute("CREATE TABLE registers(id INTEGER PRIMARY KEY, alfanumerico TEXT, numero TEXT)");
  }
}