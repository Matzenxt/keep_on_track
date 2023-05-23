import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/database.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:sqflite/sqflite.dart';

class TodoDatabaseHelper {
  static Future<int> addTodo(ToDo todo) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert("Todo", todo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateTodo(ToDo todo) async {
    final db = await DatabaseHelper.getDB();

    NotificationService().updateNotificationTodo(todo);

    return await db.update("Todo", todo.toJson(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // TODO: Refactor to just update notification id column.
  static Future<int> addNotificationID(ToDo todo) async {
    final db = await DatabaseHelper.getDB();
    return await db.update("Todo", todo.toJson(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteTodo(ToDo todo) async {
    final db = await DatabaseHelper.getDB();

    if(todo.notificationID != null) {
      NotificationService().cancelTodoNotification(todo);
    }

    return await db.delete(
      "Todo",
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  static Future<List<ToDo>?> getAllTodos() async {
    final db = await DatabaseHelper.getDB();

    final List<Map<String, dynamic>> maps = await db.query("Todo");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => ToDo.fromJson(maps[index]));
  }
}
