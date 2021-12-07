import 'dart:io';
import 'package:api1/models/profile.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;
  final String tableProfile = "Profile";
  final String columnName = "name";
  final String columnProfileName = "profilename";
  final String columnPassword = "password";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Profile(id INTEGER PRIMARY KEY, name TEXT, profilename TEXT, password TEXT, flaglogado TEXT)");
    print("Table is created");
  }

  //insertion
  Future<int> saveProfile(Profile profile) async {
    var dbClient = await db;
    print(profile.name);
    int res = await dbClient.insert("Profile", profile.toMap());
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Profile');
    print("Imprindo a tabela");
    print(list);
    return res;
  }

  //deletion
  Future<int> deleteProfile(Profile profile) async {
    var dbClient = await db;
    int res = await dbClient.delete("Profile");
    return res;
  }

  Future<Profile> selectProfile(Profile profile) async {
    print("Select Profile");
    print(profile.profilename);
    print(profile.password);
    var dbClient = await db;
    List<Map> maps = await dbClient.query(tableProfile,
        columns: [columnProfileName, columnPassword],
        where: "$columnProfileName = ? and $columnPassword = ?",
        whereArgs: [profile.profilename, profile.password]);
    print(maps);
    if (maps.length > 0) {
      print("Achou");
      return profile;
    } else {
      return null;
    }
  }
}
