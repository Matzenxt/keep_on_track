import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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

  notificationDetails() {
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

  Future showNotification({ int id = 0, String? title, String? body, String? payLoad}) {
    return flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails(), payload: payLoad);
  }

  Future<void> showScheduledNotification(
  {int id = 0,
  String? title,
  String? body,
  required int seconds}
      ) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 20)),
        notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}
