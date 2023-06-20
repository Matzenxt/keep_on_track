import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:keep_on_track/components/drawer.dart';
import 'package:keep_on_track/screens/appointment.dart';
import 'package:keep_on_track/screens/learning_material.dart';
import 'package:keep_on_track/screens/lecture/lectures.dart';
import 'package:keep_on_track/screens/timetable.dart';
import 'package:keep_on_track/screens/todo/todos.dart';
import 'package:keep_on_track/services/notification_service.dart';

DateTime semesterStart = DateTime(2023, 4, 10);
DateTime semesterEnd = DateTime(2023, 7, 7);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep on track',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('de')
      ],
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
        title: const Text('Keep on Track'),
        actions: const <Widget>[
        ],
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.lightBlue,
                minWidth: double.infinity,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TimeTable()),
                  );
                },
                child: const Text("Studenplan")
              ),
              MaterialButton(
                  color: Colors.lightBlue,
                  minWidth: double.infinity,
                  onPressed:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Todos()),
                    );
                  },
                  child: const Text("ToDo's")
              ),
              MaterialButton(
                  color: Colors.lightBlue,
                  minWidth: double.infinity,
                  onPressed:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LearningMaterial()),
                    );
                  },
                  child: const Text("Lernstoff")
              ),
              MaterialButton(
                  color: Colors.lightBlue,
                  minWidth: double.infinity,
                  onPressed:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Lectures()),
                    );
                  },
                  child: const Text("Vorlesungen")
              ),
              MaterialButton(
                  color: Colors.lightBlue,
                  minWidth: double.infinity,
                  onPressed:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Appointment()),
                    );
                  },
                  child: const Text("Terminübersicht")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
