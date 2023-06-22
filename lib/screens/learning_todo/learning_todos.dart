import 'package:flutter/material.dart';
import 'package:keep_on_track/components/drawer.dart';
import 'package:keep_on_track/components/leraning_todo/learning_todo_row.dart';
import 'package:keep_on_track/data/model/learning_todo.dart';
import 'package:keep_on_track/screens/learning_todo/learning_todo.dart';
import 'package:keep_on_track/services/database/learning_todo.dart';


class LearningTodos extends StatefulWidget {
  const LearningTodos({super.key});

  @override
  State<LearningTodos> createState() => _LearningTodosState();
}

class _LearningTodosState extends State<LearningTodos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lernstoff Liste'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
            LearningTodoScreen(
              learningTodo: null,
              deleteLearningTodo: () {}
            ),
          ));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<LearningTodo>?>(
        future: LearningTodoDatabaseHelper.getAll(),
        builder: (context, AsyncSnapshot<List<LearningTodo>?> snapshot) {
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
                    LearningTodoRow(
                        learningTodo: snapshot.data![index],
                      deleteLearningTodo: () => {
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
              child: Text("Gerade gibt es nichts zum lernen :)"),
            );
          }
        },
      ),
    );
  }
}
