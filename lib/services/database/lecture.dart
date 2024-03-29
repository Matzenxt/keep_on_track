import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/services/database/database.dart';
import 'package:keep_on_track/services/database/time_slot.dart';
import 'package:keep_on_track/services/database/todo.dart';
import 'package:sqflite/sqflite.dart';

class LectureDatabaseHelper {
  static const String tableName = 'Lecture';

  static Future<int> add(Lecture lecture) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert(tableName, lecture.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(Lecture lecture) async {
    final db = await DatabaseHelper.getDB();
    return await db.update(tableName, lecture.toJson(),
        where: 'id = ?',
        whereArgs: [lecture.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> delete(Lecture lecture) async {
    TodoDatabaseHelper.deleteByLecture(lecture.id!);
    TimeSlotDatabaseHelper.deleteByLecture(lecture.id!);

    final db = await DatabaseHelper.getDB();
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [lecture.id],
    );
  }

  static Future<List<Lecture>?> getAll() async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Lecture.fromJson(maps[index]));
  }

  static Future<Lecture?> getByID(int id) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) {
      return null;
    }

    return Lecture.fromJson(result[0]);
  }
}
