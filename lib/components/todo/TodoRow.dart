import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/screens/todo/todo.dart';
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
      child: Row(
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
          IconButton(
            icon: const Icon(Icons.alarm),
            tooltip: 'Benachrichtigung',
            onPressed: () {
              // TODO: Functionality
              setState(() {});
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      widget.todo.title,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1 ,
                    indent : 10,
                    endIndent : 10,
                  ),
                  Text(
                    widget.todo.note,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          // TODO: Take max width with title and note or align edit iconbutton to the right.
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Bearbeiten',
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => TodoScreen(todo: widget.todo,)));
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
