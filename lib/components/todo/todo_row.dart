import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/screens/todo/todo.dart';
import 'package:keep_on_track/services/database/todo.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:tuple/tuple.dart';

class TodoRow extends StatefulWidget {
  final Function deleteTodo;

  final ToDo todo;

  const TodoRow({super.key, required this.todo, required this.deleteTodo});

  @override
  State<TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<TodoRow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Checkbox(
              checkColor: Colors.white,
              value: widget.todo.done,
              onChanged: (bool? value) async {
                widget.todo.done = value!;
                await TodoDatabaseHelper.updateTodo(widget.todo);
                // TODO: When changed to done, cancel notification.
                // TODO: When changed to todo, add notification back if wanted.
                // TODO: Update notification time when datetime is changed.
                setState(() {});
              },
            ),
            IconButton(
              icon: widget.todo.notificationID != null ? const Icon(Icons.alarm) : const Icon(Icons.alarm_off),
              tooltip: 'Benachrichtigung',
              onPressed: () async {
                if(widget.todo.alertDate != null) {
                  if(widget.todo.notificationID == null) {
                    Tuple2<bool, String> temp = await NotificationService().scheduleNotificationTodo(widget.todo);

                    if(temp.item1) {
                      setState(() {
                      });

                      const snackBar = SnackBar(content: Text('Benachrichtigung aktiviert.'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      setState(() {
                        widget.todo.notificationID = null;
                      });

                      final snackBar = SnackBar(content: Text('Fehler beim aktiveren der Benachrichtigung: ${temp.item2}'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } else {
                    await NotificationService().cancelTodoNotification(widget.todo);

                    setState(() {
                      widget.todo.notificationID = null;
                    });

                    const snackBar = SnackBar(content: Text("Benachrichtigung deaktiviert"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  const snackBar = SnackBar(content: Text("Kein Datum für die Benachrichtigung gesetzt."));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  children: [
                    Text(
                      widget.todo.title,
                      textAlign: TextAlign.left,
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
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Bearbeiten',
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      TodoScreen(
                        todo: widget.todo,
                        deleteTodo: widget.deleteTodo,
                      )
                  ));
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
