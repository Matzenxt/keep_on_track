import 'package:keep_on_track/data/model/Notification.dart';
import 'package:keep_on_track/data/model/learning_todo.dart';
import 'package:keep_on_track/services/database/database.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:sqflite/sqflite.dart';

import 'notification.dart';

class LearningTodoDatabaseHelper {
  static const String tableName = 'LearningTodo';

  static Future<int> add(LearningTodo learningTodo) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert(tableName, learningTodo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> update(LearningTodo learningTodo) async {
    final db = await DatabaseHelper.getDB();

    if(learningTodo.done && learningTodo.notificationID != null) {
      await NotificationService().cancelLearningTodoNotification(learningTodo);
      learningTodo.notificationID = null;
    }

    if(learningTodo.notificationID != null) {
      await NotificationService().updateNotificationLearningTodo(learningTodo);
    }

    return await db.update(tableName, learningTodo.toJson(),
        where: 'id = ?',
        whereArgs: [learningTodo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addNotificationID(LearningTodo learningTodo) async {
    final db = await DatabaseHelper.getDB();

    return await db.rawUpdate('UPDATE $tableName SET notificationID = ? WHERE id = ?', [learningTodo.notificationID, learningTodo.id]);
  }

  static Future<int> removeNotificationID(LearningTodo learningTodo) async {
    final db = await DatabaseHelper.getDB();
    await NotificationDatabaseHelper.delete(Notification(id: learningTodo.notificationID, notificationFor: NotificationFor.todo, alarmDateTime: DateTime.now()));

    return await db.rawUpdate('UPDATE $tableName SET notificationID = ? WHERE id = ?', [null, learningTodo.id]);
  }

  static Future<int> delete(LearningTodo learningTodo) async {
    final db = await DatabaseHelper.getDB();

    if(learningTodo.notificationID != null) {
      await NotificationService().cancelLearningTodoNotification(learningTodo);
    }

    final List<LearningTodo>? learnings = await getByParentLearningTodo(learningTodo.id!);

    if(learnings != null) {
      for(LearningTodo todo in learnings) {
        delete(todo);
      }
    }

    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [learningTodo.id],
    );
  }

  static Future<int> deleteByLecture(int lectureID) async {
    final db = await DatabaseHelper.getDB();
    return await db.delete(
      tableName,
      where: 'lectureID = ?',
      whereArgs: [lectureID],
    );
  }

  static Future<List<LearningTodo>?> getAll() async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> maps = await db.query(tableName);

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => LearningTodo.fromJson(maps[index]));
  }

  static Future<List<LearningTodo>?> getByParentLearningTodo(int parentId) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'parentId = ?',
      whereArgs: [parentId],
    );

    if (result.isEmpty) {
      return null;
    }

    return List.generate(result.length, (index) => LearningTodo.fromJson(result[index]));
  }

  static Future<List<LearningTodo>?> getByLecture(int lectureID) async {
    final db = await DatabaseHelper.getDB();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'lectureID = ?',
      whereArgs: [lectureID],
    );

    if (result.isEmpty) {
      return null;
    }

    return List.generate(result.length, (index) => LearningTodo.fromJson(result[index]));
  }
}
