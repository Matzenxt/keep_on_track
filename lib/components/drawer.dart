import 'package:flutter/material.dart';
import 'package:keep_on_track/lernstoff/lernstoff.dart';
import 'package:keep_on_track/termin/termin.dart';
import 'package:keep_on_track/todos/todos.dart';
import 'package:keep_on_track/vorlesung/vorlesung.dart';

import '../stundenplan/studenplan.dart';

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
                MaterialPageRoute(builder: (context) => const Stundenplan()),
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
                MaterialPageRoute(builder: (context) => const Lernstoff()),
              );
            },
          ),
          ListTile(
            title: const Text('Vorlesungen'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Vorlesung()),
              );
            },
          ),
          ListTile(
            title: const Text('Terminübersicht'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Termin()),
              );
            },
          ),
        ],
      ),
    );
  }
}