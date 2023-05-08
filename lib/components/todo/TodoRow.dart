import 'package:flutter/cupertino.dart';
import 'package:keep_on_track/data/model/todo.dart';

class TodoRow extends StatelessWidget {
  final ToDo todo;

  const TodoRow({super.key, required this.todo});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Titel: ${todo.title}"
      ),
    );
  }
}