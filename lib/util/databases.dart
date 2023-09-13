import 'dart:async';

import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Databases {
  final String dbName = "DataBase";
  Database? db;
  int? version;

  // return the path
  Future<String> checkDb(String dbName, {bool deleteOldDb = false}) async {
    var databasePath = await getDatabasesPath();
    // print(databasePath);
    String path = join(databasePath, dbName);

    // make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      if (deleteOldDb) {
        await deleteDatabase(path);
      }
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        // ignore: use_rethrow_when_possible
        throw (e);
      }
    }
    return path;
  }

  Future<Databases> initializeDb({
    bool deleteOldDb = false,
    Function(Database?, int)? onCreate,
  }) async {
    String path = await checkDb(dbName, deleteOldDb: deleteOldDb);
    db = await openDatabase(path);
    db?.getVersion().then((version) {
      version = version;
      if (onCreate != null) {
        onCreate(db, version);
      }
    });
    db = db;
    return this;
  }

  Future<Database?> openConnection() async {
    String path = await checkDb(dbName);
    db = await openDatabase(path);
    db = db;
    return db;
  }

  Future<void> closeConnection() async {
    try {
      return db?.close().then((onValue) {
        return;
      }).catchError((onError) {
        throw onError;
      });
    } catch (e) {
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  static Future<List<Map<String, Object?>>>? readSchema(Database? db) {
    String sql =
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;";
    return db?.rawQuery(sql);
  }

  void startMigration(int version) {}
}
