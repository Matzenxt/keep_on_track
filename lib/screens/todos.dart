import 'package:flutter/material.dart';
import 'package:keep_on_track/components/todo/todo.dart';

import '../components/drawer.dart';

class Todos extends StatelessWidget {
  const Todos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo\'s'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (context) {
                return TodoDialog();
              });
        },
        child: const Icon(Icons.add),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
