
import 'package:flutter_app_wiki/model/search_results.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'pageid';
  static const String NAME = 'title';
  static const String DESCRIPTION = 'description';
  static const String BTMNAME = 'btmphoto_name';
  static const String WEAR = 'wear';
  static const String SAVED = 'saved';
  static const String TABLE = 'PhotosTable';
  static const String RANDOMTABLE = 'RandomPhotosTable';
  static const String FAVTABLE = 'favPhotosTable';
  static const String DB_NAME = 'photos.db';

  DBHelper._constr();
  static final DBHelper dbInstance = new DBHelper._constr();
  factory DBHelper() => dbInstance;


  //create the database object and its getter

  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT, $DESCRIPTION TEXT)");
  }

  Future<Pages> save(Pages employee) async {
    var dbClient = await db;
    var map={ID:employee.pageid,NAME:employee.title,DESCRIPTION:employee.terms?.description[0]??""};
   /* employee.id =*/var  result= await dbClient.insert(TABLE, map);
    // print("Photo.toMap${employee.saved}");
    print("createCustomer  ${result.toString()}");
    return employee;
  }


  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<List<Pages>> getPages() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME,DESCRIPTION]);
    print("Photo.fromMap${maps}");
    List<Pages> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        var pages= Pages();
        pages.title=maps[i][NAME];
        pages.pageid=maps[i][ID];
        pages.terms=Terms();
        pages.terms.description=[];
        pages.terms.description.add(maps[i][DESCRIPTION]);
        employees.add(pages);
        // print("Photo.fromMap${Photo.fromMap(maps[i]).saved}");
      }
    }
    return employees;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
