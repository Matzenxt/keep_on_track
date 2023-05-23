import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:keep_on_track/data/model/Notification.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/notification.dart';
import 'package:keep_on_track/services/database/todo.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tuple/tuple.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('icon');
    DarwinInitializationSettings darwinInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {}
    );

    var initSettings = InitializationSettings(
        android: androidInitializationSettings,
      iOS: darwinInitializationSettings
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {}
    );
  }

  _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'channelId2',
          'channelName',
        channelDescription: 'Test Beschreibung',
        importance: Importance.max,
        playSound: false,
      ),
      iOS: DarwinNotificationDetails()
    );
  }

  notificationDetailsTodo() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          '2',
          'Todos',
          channelDescription: 'Benachrichtigungen für Todo\'s',
          importance: Importance.max,
          playSound: false,
        ),
        iOS: DarwinNotificationDetails()
    );
  }

  Future showNotification({ int id = 0, String? title, String? body, String? payLoad}) {
    return flutterLocalNotificationsPlugin.show(id, title, body, _notificationDetails(), payload: payLoad);
  }

  Future<Tuple2<bool, String>> scheduleNotificationTodo(ToDo todo) async {
    if(todo.alertDate != null && !todo.alertDate!.difference(DateTime.now()).isNegative) {
      Notification notification = Notification(notificationFor: NotificationFor.todo, alarmDateTime: todo.alertDate!);
      int ret = await NotificationDatabaseHelper.add(notification);

      todo.notificationID = ret;
      TodoDatabaseHelper.updateTodo(todo);

      scheduledNotification(
          id: todo.notificationID!,
          title: 'Todo: ${todo.title}',
          body: 'Notiz: ${todo.note}',
          alarmDate: todo.alertDate!,
          notificationDetails: NotificationService().notificationDetailsTodo()
      );

      return const Tuple2(true, 'Benachrichtigung erfolgreich hinzugefügt.');
    } else {
      return const Tuple2(false, 'Fehler beim Benachrichtigung hinzufügen. Datum liegt in der Vergangenheit!');
    }
  }

  Future<void> cancelTodoNotification(ToDo todo) async {
    if(todo.notificationID != null) {
      await flutterLocalNotificationsPlugin.cancel(todo.notificationID!);

      final notification = await NotificationDatabaseHelper.getByID(todo.notificationID!);

      if(notification != null) {
        NotificationDatabaseHelper.delete(notification);
      }

      todo.notificationID = null;
      await TodoDatabaseHelper.updateTodo(todo);
    }
  }

  Future<void> scheduledNotification(
    {int id = 0,
    String? title,
    String? body,
    required NotificationDetails notificationDetails,
    required DateTime alarmDate}
  ) async {
    DateTime now = DateTime.now();
    Duration duration = alarmDate.difference(now);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(duration),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}
