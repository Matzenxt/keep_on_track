import 'package:flutter/material.dart';
import 'package:keep_on_track/components/todo/TodoRow.dart';
import 'package:keep_on_track/components/todo/todo.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/todo.dart';

import '../components/drawer.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
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
      body: FutureBuilder<List<ToDo>?>(
        future: TodoDatabaseHelper.getAllTodos(),
        builder: (context, AsyncSnapshot<List<ToDo>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Fehler beim Laden: " + snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => TodoRow(todo: snapshot.data![index]),
                itemCount: snapshot.data!.length,
              );
            } else {
              return Center(
                child: Text("Data null"),
              );
            }
          } else {
            return Center(
              child: Text("Fehler bei Snapshot"),
            );
          }
        },
      ),
    );
  }
}
