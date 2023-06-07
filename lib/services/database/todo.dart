import 'package:keep_on_track/data/model/Notification.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/database.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:sqflite/sqflite.dart';

import 'notification.dart';

class TodoDatabaseHelper {
  static Future<int> addTodo(ToDo todo) async {
    final db = await DatabaseHelper.getDB();
    return await db.insert("Todo", todo.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateTodo(ToDo todo) async {
    final db = await DatabaseHelper.getDB();

    if(todo.done && todo.notificationID != null) {
      await NotificationService().cancelTodoNotification(todo);
      todo.notificationID = null;
    }

    if(todo.notificationID != null) {
      await NotificationService().updateNotificationTodo(todo);
    }

    return await db.update("Todo", todo.toJson(),
        where: 'id = ?',
        whereArgs: [todo.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addNotificationID(ToDo todo) async {
    final db = await DatabaseHelper.getDB();

    return await db.rawUpdate('UPDATE Todo SET notificationID = ? WHERE id = ?', [todo.notificationID, todo.id]);
  }

  static Future<int> removeNotificationID(ToDo todo) async {
    final db = await DatabaseHelper.getDB();
    await NotificationDatabaseHelper.delete(Notification(id: todo.notificationID, notificationFor: NotificationFor.todo, alarmDateTime: DateTime.now()));

    return await db.rawUpdate('UPDATE Todo SET notificationID = ? WHERE id = ?', [null, todo.id]);
  }

  static Future<int> deleteTodo(ToDo todo) async {
    final db = await DatabaseHelper.getDB();

    if(todo.notificationID != null) {
      await NotificationService().cancelTodoNotification(todo);
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
