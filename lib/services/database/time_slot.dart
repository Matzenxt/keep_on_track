import 'package:keep_on_track/data/model/time_slot.dart';
import 'package:keep_on_track/services/database/database.dart';
import 'package:sqflite/sqflite.dart';

class TimeSlotDatabaseHelper {
  static const String tableName = 'TimeSlot';

  static Future<int> add(TimeSlot timeSlot) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert(tableName, timeSlot.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(TimeSlot timeSlot) async {
    final db = await DatabaseHelper.getDB();
    return await db.update(tableName, timeSlot.toJson(),
        where: 'id = ?',
        whereArgs: [timeSlot.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> delete(TimeSlot timeSlot) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [timeSlot.id],
    );
  }

  static Future<List<TimeSlot>> getAll() async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return [];
    }

    return List.generate(maps.length, (index) => TimeSlot.fromJson(maps[index]));
  }

  static Future<TimeSlot?> getByID(int id) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return TimeSlot.fromJson(result[0]);
  }

  static Future<List<TimeSlot>?> getByLecture(int lectureID) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'lectureID = ?',
      whereArgs: [lectureID],
    );

    if (result.isEmpty) {
      return null;
    }

    return List.generate(result.length, (index) => TimeSlot.fromJson(result[index]));
  }

  static Future<int> deleteByLecture(int lectureID) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      tableName,
      where: 'lectureID = ?',
      whereArgs: [lectureID],
    );
  }
}
