import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/data/model/todo.dart';
import 'package:keep_on_track/screens/todo/todo.dart';
import 'package:keep_on_track/services/database/lecture.dart';
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
  Color backgroundColor = Colors.black12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: FutureBuilder<Lecture?>(
        future: _getLecture(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData) {
            backgroundColor = snapshot.data!.color;
          }

          return Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    checkColor: Colors.black,
                    value: widget.todo.done,
                    onChanged: (bool? value) async {
                      widget.todo.done = value!;
                      await TodoDatabaseHelper.updateTodo(widget.todo);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: widget.todo.notificationID != null && widget.todo.alertDate != null && widget.todo.alertDate!.isAfter(DateTime.now()) ? const Icon(Icons.alarm) : const Icon(Icons.alarm_off),
                    color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                    Colors.white :
                    Colors.black,
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

                            final snackBar = SnackBar(content: Text(temp.item2));
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
                            style: TextStyle(
                              color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                              Colors.white :
                              Colors.black,
                            ),
                          ),
                          Divider(
                            color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                            Colors.white :
                            Colors.black,
                            thickness: 1 ,
                            indent : 10,
                            endIndent : 10,
                          ),
                          Text(
                            widget.todo.note,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                              Colors.white :
                              Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                      Colors.white :
                      Colors.black,
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
        },
      ),
    );
  }

  Future<Lecture?> _getLecture() async {
    return await LectureDatabaseHelper.getByID(widget.todo.lectureID!);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.selected,
      MaterialState.focused,
      MaterialState.pressed,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }

    return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
    Colors.white :
    Colors.black;
  }
}
