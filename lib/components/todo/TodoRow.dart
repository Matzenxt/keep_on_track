import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/services/database/todo.dart';

class TodoRow extends StatefulWidget {
  final ToDo todo;

  const TodoRow({super.key, required this.todo});

  @override
  State<TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<TodoRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          value: widget.todo.done,
          onChanged: (bool? value) async {
            widget.todo.done = value!;
            await TodoDatabaseHelper.updateTodo(widget.todo);
            setState(() {});
          },
        ),
        Icon(Icons.alarm),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              Text(widget.todo.title),
              Text(widget.todo.note),
            ],
          ),
        ),
      ],
    );
  }
}
