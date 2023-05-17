import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "keep_on_track.db";

  static Future<Database> getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE Todo(id INTEGER PRIMARY KEY, done INTEGER NOT NULL DEFAULT 0, title TEXT NOT NULL, note TEXT, alert TEXT DEFAULT NULL);");
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          for (var version = oldVersion + 1; version <= newVersion; version++) {
            switch (version) {
              case 1: {
                //Version 1 - no changes
                break;
              }
              case 2: {
                // Add changes
                // db.execute("...");
                break;
              }
            }
          }
        },
        version: _version
    );
  }
}
