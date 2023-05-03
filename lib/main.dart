import 'package:flutter/material.dart';
import 'package:keep_on_track/components/drawer.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:keep_on_track/lernstoff/lernstoff.dart';
import 'package:keep_on_track/stundenplan/studenplan.dart';
import 'package:keep_on_track/termin/termin.dart';
import 'package:keep_on_track/todos/todos.dart';
import 'package:keep_on_track/vorlesung/vorlesung.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep on track',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Keep on track'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
        ],
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Stundenplan()),
                  );
                },
                child: Text("Studenplan")
            ),
            TextButton(
                onPressed:  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Todos()),
                  );
                },
                child: Text("ToDo's")),
            TextButton(
                onPressed:  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Lernstoff()),
                  );
                },
                child: Text("Lernstoff")),
            TextButton(
                onPressed:  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Vorlesung()),
                  );
                },
                child: Text("Vorlesungen")),
            TextButton(
                onPressed:  () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Termin()),
                  );
                },
                child: Text("Terminübersicht")),
            TextButton(
                onPressed: () async {
                  await testNotif();
                },
                child: Text("Show notification")
            ),

            TextButton(
                onPressed: () async {
                  await testNotifSche();
                },
                child: Text("Schedule notification")
            )
          ],
        ),
      ),
    );
  }

  testNotif() async {
    NotificationService().showNotification(title: 'Test', body: 'Test body');
  }

  testNotifSche() async {
    NotificationService().showScheduledNotification(id: 1, title: 'Test', body: 'Test body', seconds: 30);
  }
}
