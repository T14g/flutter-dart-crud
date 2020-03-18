import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'banco');
    var database = await openDatabase(path, version: 1, onCreate: _onCreateDb);

    return database;
  }

  //Private _

  //Fields
  // id , alfanumerico,inteiro,decimal,dia,selecionado
  _onCreateDb(Database db, int version) async{
    await db.execute("CREATE TABLE registers(id INTEGER PRIMARY KEY, alfanumerico TEXT, inteiro TEXT, decimal TEXT, dia TEXT, selecionado TEXT)");
  }
}