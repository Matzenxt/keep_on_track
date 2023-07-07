import 'package:flutter/material.dart';
import 'package:keep_on_track/screens/appointment.dart';
import 'package:keep_on_track/screens/learning_todo/learning_todos.dart';
import 'package:keep_on_track/screens/lecture/lectures.dart';
import 'package:keep_on_track/screens/todo/todos.dart';

import '../screens/timetable.dart';

class CustomDrawer extends Drawer {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
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
                MaterialPageRoute(builder: (context) => const LearningTodos()),
              );
            },
          ),
          ListTile(
            title: const Text('Vorlesungen'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Lectures()),
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
