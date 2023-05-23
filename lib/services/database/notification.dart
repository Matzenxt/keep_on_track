import 'package:keep_on_track/data/model/Notification.dart';
import 'package:keep_on_track/services/database/database.dart';
import 'package:sqflite/sqflite.dart';

class NotificationDatabaseHelper {
  static const String tableName = 'Notification';

  static Future<int> add(Notification notification) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert(tableName, notification.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(Notification notification) async {
    final db = await DatabaseHelper.getDB();
    return await db.update(tableName, notification.toJson(),
        where: 'id = ?',
        whereArgs: [notification.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> delete(Notification notification) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  static Future<Notification?> getByID(int id) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return Notification.fromJson(result[0]);
  }

  static Future<List<Notification>?> getAll() async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Notification.fromJson(maps[index]));
  }
}
