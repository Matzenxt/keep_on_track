import 'package:flutter/material.dart';
import 'package:keep_on_track/data/model/learning_todo.dart';
import 'package:keep_on_track/data/model/lecture.dart';
import 'package:keep_on_track/screens/learning_todo/learning_todo.dart';
import 'package:keep_on_track/services/database/learning_todo.dart';
import 'package:keep_on_track/services/database/lecture.dart';
import 'package:keep_on_track/services/notification_service.dart';
import 'package:tuple/tuple.dart';

class LearningTodoRow extends StatefulWidget {
  final Function deleteLearningTodo;

  final LearningTodo learningTodo;

  const LearningTodoRow({super.key, required this.learningTodo, required this.deleteLearningTodo});

  @override
  State<LearningTodoRow> createState() => _LearningTodoRowState();
}

class _LearningTodoRowState extends State<LearningTodoRow> {
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Checkbox(
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        checkColor: Colors.black,
                        value: widget.learningTodo.done,
                        onChanged: (bool? value) async {
                          widget.learningTodo.done = value!;
                          await LearningTodoDatabaseHelper.update(widget.learningTodo);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: widget.learningTodo.notificationID != null ? const Icon(Icons.alarm) : const Icon(Icons.alarm_off),
                        color: ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark ?
                        Colors.white :
                        Colors.black,
                        tooltip: 'Benachrichtigung',
                        onPressed: () async {
                          if(widget.learningTodo.alertDate != null) {
                            if(widget.learningTodo.notificationID == null) {
                              Tuple2<bool, String> temp = await NotificationService().scheduleNotificationLearningTodo(widget.learningTodo);

                              if(temp.item1) {
                                setState(() {
                                });

                                const snackBar = SnackBar(content: Text('Benachrichtigung aktiviert.'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                setState(() {
                                  widget.learningTodo.notificationID = null;
                                });

                                final snackBar = SnackBar(content: Text(temp.item2));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            } else {
                              await NotificationService().cancelLearningTodoNotification(widget.learningTodo);

                              setState(() {
                                widget.learningTodo.notificationID = null;
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
                                widget.learningTodo.title,
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
                                widget.learningTodo.note,
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
                                LearningTodoScreen(
                                  learningTodo: widget.learningTodo,
                                  deleteLearningTodo: widget.deleteLearningTodo,
                                )
                            ));
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {},
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text('asdf'),
                        );
                      },
                      body: ListTile(
                        title: Text('Body title'),
                        subtitle: Text('body sub'),
                      ),
                      isExpanded: true,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Lecture?> _getLecture() async {
    return await LectureDatabaseHelper.getByID(widget.learningTodo.lectureID!);
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
