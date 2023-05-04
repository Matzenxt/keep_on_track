import 'package:flutter/material.dart';
import 'package:keep_on_track/screens/appointment.dart';
import 'package:keep_on_track/screens/learning material.dart';
import 'package:keep_on_track/screens/lecture.dart';
import 'package:keep_on_track/screens/todos.dart';

import '../screens/timetable.dart';

class CustomDrawer extends Drawer {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text("Countdown Klausurphase")
          ),
          ListTile(
            title: const Text('Stundenplan'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimeTable()),
              );
            },
          ),
          ListTile(
            title: const Text('ToDo\'s'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Todos()),
              );
            },
          ),
          ListTile(
            title: const Text('Lernstoff'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LearningMaterial()),
              );
            },
          ),
          ListTile(
            title: const Text('Vorlesungen'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lecture()),
              );
            },
          ),
          ListTile(
            title: const Text('Terminübersicht'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Appointment()),
              );
            },
          ),
        ],
      ),
    );
  }
}
