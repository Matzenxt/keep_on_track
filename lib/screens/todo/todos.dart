import 'package:flutter/material.dart';
import 'package:keep_on_track/components/drawer.dart';
import 'package:keep_on_track/components/todo/todo_row.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/screens/todo/todo.dart';
import 'package:keep_on_track/services/database/todo.dart';


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
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
            TodoScreen(
              todo: null,
              deleteTodo: () => {},
            )
          ));
          setState(() {});
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
              child: Text("Fehler beim Laden: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    TodoRow(
                        todo: snapshot.data![index],
                      deleteTodo: () => {
                        setState(() {
                          snapshot.data!.remove(snapshot.data![index]);
                        })
                      },
                    ),
                itemCount: snapshot.data!.length,
              );
            } else {
              return const Center(
                child: Text("Data null"),
              );
            }
          } else {
            return const Center(
              child: Text("Gerade gibt es nichts zu tun :)"),
            );
          }
        },
      ),
    );
  }
}
